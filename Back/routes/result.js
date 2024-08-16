const express = require('express');
const PDFDocument = require('pdfkit');
const { ChartJSNodeCanvas } = require('chartjs-node-canvas');
const connectToOracle = require('../config/db'); 
const path = require('path');
const AuthToken = require('../AuthToken');
const fs = require('fs'); 
const sharp = require("sharp");

const router = express.Router();

async function getClobAsString(clob) {
  if (clob === null || clob === undefined) {
    return ' '; 
  }

  let clobString = '';
  
  try {
    const lobStream = clob;
    let chunks = []; 

    lobStream.on('data', chunk => {
      chunks.push(chunk);
    });

    lobStream.on('end', () => {
      clobString = Buffer.concat(chunks).toString();
    });

    lobStream.on('error', error => {
      throw error;
    });

    await new Promise((resolve, reject) => {
      lobStream.on('end', resolve);
      lobStream.on('error', reject);
    });
  } catch (error) {
    throw error;
  }

  return clobString;
}

async function getBlobAsBase64(lob) {
  return new Promise((resolve, reject) => {
    if (!lob) {
      return resolve(null);
    }

    const chunks = [];

    lob.on('data', (chunk) => {
      chunks.push(chunk);
    });

    lob.on('end', () => {
      const buffer = Buffer.concat(chunks);
      const base64String = buffer.toString('base64');
      resolve(base64String);
    });

    lob.on('error', (err) => {
      reject(err);
    });
  });
}

function decodeBase64ToNumberArray(base64String) {
  try {
    const buffer = Buffer.from(base64String, 'base64');
    const floatArray = new Float64Array(buffer.buffer, buffer.byteOffset, buffer.length / Float64Array.BYTES_PER_ELEMENT);
    return Array.from(floatArray).map(num => parseFloat(num.toFixed(3)));
  } catch (error) {
    return [];
  }
}

async function generateECGChart(ecgData) {
  const width = 1200;
  const height = 400;
  const chartJSNodeCanvas = new ChartJSNodeCanvas({ width, height });

  const labels = ecgData.map((_, index) => (index).toString());

  const configuration = {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        data: ecgData,
        borderColor: 'rgba(255, 0, 0, 1)',
        borderWidth: 2,
        fill: false,
        tension: 0,
        showLine: true,
        pointRadius: 0,
      }],
    },
    options: {
      responsive: false,
      scales: {
        x: { 
          display: true,
          grid: {
            display: false,
            drawBorder: false,
          },
          ticks: {
            display: false,
            autoSkip: false,
            maxRotation: 0, 
            minRotation: 0,
          },
          title: {
            display: false,
          },
        },
        y: { 
          display: true,
          grid: {
            display: false
          },
          ticks: {
            display: false,
            autoSkip: false,
            maxRotation: 0, 
            minRotation: 0,
          },
          title: {
            display: false,
          },
        },
      },
      plugins: {
        legend: {
          display: false
        },
      },
      elements: {
        line: {
          borderWidth: 2,
          borderColor: 'rgba(105, 105, 105, 1)',
          borderDash: [],
        },
      }
    },
  };
  return await chartJSNodeCanvas.renderToBuffer(configuration);
}

function getMaxValueFromResult(resultString) {
  const regex = /([A-Z/]): (\d+\.\d+)/g;
  let match;
  const values = {};

  while ((match = regex.exec(resultString)) !== null) {
    values[match[1]] = parseFloat(match[2]);
  }

  if (Object.keys(values).length === 0) {
    return 'No valid data found';
  }

  const maxKey = Object.keys(values).reduce((a, b) => values[a] > values[b] ? a : b);
  const maxValue = values[maxKey].toFixed(4);

  const messages = {
    'N': `정상 심박수(Normal beats)`,
    'R': `우각차단(Right bundle branch block) 가능성 있음`,
    'L': `좌각차단(Left bundle branch block) 가능성 있음`,
    'V': `심실 이소성 박동 및 심실 조기 수축(Ventricular ectopic beats and ventricular premature contraction) 가능성 있음`,
    '/': `인공 심박 조율기 박동(paced beat) 가능성 있음`
  };

  return messages[maxKey] || `알 수 없는 항목: ${maxValue}`;
}

router.post('/downloadPdf', AuthToken, async (req, res) => {
  const userId = req.user.id;
  const { analysisId } = req.body;
  let connection;

  try {
    connection = await connectToOracle();

    const analysisResult = await connection.execute(
      `SELECT ID, BP_AVG, rr_min, rr_max, rr_avg, rr_std, SUBSTR(TO_CHAR(CREATED_AT, 'YYYY/MM/DD HH24:MI:SS'), 1, 16) , ANALISYS_RESULT, ANALISYS_ETC, ECG
       FROM TB_ANALYSIS
       WHERE ANALYSIS_IDX = :analisys_idx`,
      { analisys_idx: analysisId }
    );


    if (analysisResult.rows.length === 0) {
      return res.status(404).send('Analysis not found');
    }

    const analysisData = analysisResult.rows[0];
    const [
      id,
      avgHeartRate,
      rr_min,
      rr_max,
      rr_avg,
      rr_std,
      analysisDate,
      ANALISYS_RESULT,
      ANALISYS_ETC,
      ecg
    ] = analysisData;


    const analisysResultString = await getClobAsString(ANALISYS_RESULT);
    const maxAnalysisResult = getMaxValueFromResult(analisysResultString);

    const userResult = await connection.execute(
      `SELECT NAME, TO_CHAR(BIRTHDATE, 'YYYY/MM/DD'), GENDER, HEIGHT, WEIGHT FROM TB_USER WHERE ID = :userId`,
      { userId: userId }
    );

    if (userResult.rows.length === 0) {
      return res.status(404).send('User not found');
    }

    const [name, birthdate, gender, height, weight] = userResult.rows[0];

    const analisysEtcString = await getClobAsString(ANALISYS_ETC);

    const ecgBase64 = await getBlobAsBase64(ecg);
    const ecgData = decodeBase64ToNumberArray(ecgBase64);

    const checkIconPath = path.join(__dirname, '../../Front/img/check.png');
    const reportIconPath = path.join(__dirname, '../../Front/img/report.png');
    const reportIcon = path.join(__dirname, '../../Front/img/report_modified.png');
    const boldFontPath = path.join(__dirname, '../../Front/fonts/NanumGothicBold.ttf');

    const doc = new PDFDocument({ size: 'A4', margin: 50 });
    const fontPath = path.join(__dirname, '../../Front/fonts/NanumGothic.ttf');
    doc.registerFont('NanumGothic', fontPath);
    doc.registerFont('NanumGothicBold', boldFontPath);
    doc.font('NanumGothic');
    const chunks = [];
    let pdfBuffer;

    doc.on('data', chunk => chunks.push(chunk));
    doc.on('end', () => {
      pdfBuffer = Buffer.concat(chunks);
      const filePath = path.join(__dirname, `../uploads/analysis_${userId}.pdf`);
      fs.writeFileSync(filePath, pdfBuffer);
      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader('Content-Disposition', 'attachment; filename=analysis.pdf');
      res.send(pdfBuffer);
    });

    doc.fontSize(20).font('NanumGothicBold').fillColor('black').text(`${name}님 리포트`, { align: 'center' });
    doc.moveDown();

    doc.fontSize(14).font('NanumGothic').fillColor('black').text(`생년월일 : ${birthdate}   성별 : ${gender}   키: ${height}   몸무게: ${weight}`, { align: 'center' });
    doc.moveDown();

    doc.fontSize(14).fillColor('black').text(`검사 일시: ${analysisDate}`, { align: 'center' });
    doc.moveDown(1);

    doc.fontSize(12).fillColor('red').text('리드 II');

    try {
      const ecgChartBuffer = await generateECGChart(ecgData);
      const pageWidth = doc.page.width - doc.page.margins.left - doc.page.margins.right;
      const imageHeight = 200;
      doc.image(ecgChartBuffer, doc.page.margins.left, doc.y, {
        fit: [pageWidth, imageHeight],
        align: 'center'
      });
      doc.moveDown(15);
    } catch (err) {
    }

    try {
      await sharp(reportIconPath)
        .tint({ r: 253, g: 0, b: 27 })
        .toFile(reportIcon);
      doc.image(reportIcon, doc.x, doc.y, { width: 25 });
    } catch (err) {
    }

    doc.font('NanumGothicBold')
       .fontSize(20)
       .fillColor('#fd001b')
       .text(' 검사결과', doc.x + 25, doc.y);
    doc.moveDown(1);

    let startX = doc.x;
    let startY = doc.y;
    
    // 분석 결과
    doc.image(checkIconPath, startX, doc.y + 12, { width: 15 });

    let iconHeight = 15;

    doc.font('NanumGothicBold')
      .fontSize(16)
      .fillColor('black')
      .text('분석 결과', startX + 25, startY + 10);
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(maxAnalysisResult);
    doc.moveDown(2);

    let textY = doc.y + (iconHeight - 16) / 2 - 2;

    // RR
    doc.image(checkIconPath, startX, textY + 10, { width: 15 });

    textY = doc.y + (iconHeight - 16) / 2 -2;

    doc.font('NanumGothicBold')
      .fontSize(16)
      .fillColor('black')
      .text('RR', startX + 25, textY + 9);

    doc.moveDown();
    doc.font('NanumGothic').fontSize(12);

    doc.text(`RR MIN Interval: ${rr_min} ms`, startX + 25, doc.y);
    doc.text(`RR MAX Interval: ${rr_max} ms`, startX + 275, doc.y - 14);

    doc.text(`RR AVG Interval: ${rr_avg} ms`, startX + 25, doc.y + 10);
    doc.text(`RR STD Interval: ${rr_std} ms`, startX + 275, doc.y - 14);

    doc.moveDown(2);

    // 심박수
    doc.image(checkIconPath, startX, doc.y, { width: 15 });
    textY = doc.y + (iconHeight - 16) / 2 - 2;
    doc.font('NanumGothicBold')
      .fontSize(16)
      .fillColor('black')
      .text('심박수', startX + 25, textY);
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(`평균 심박수: ${avgHeartRate} BPM`);
    doc.moveDown(2);

    
    doc.moveDown(2);

    // 분석 메모
    doc.image(checkIconPath, startX, doc.y, { width: 15 });
    textY = doc.y + (iconHeight - 16) / 2 - 2;
    doc.font('NanumGothicBold')
      .fontSize(16)
      .fillColor('black')
      .text('분석 메모', startX + 25, textY);
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(analisysEtcString);

    doc.end();
  } catch (error) {
    res.status(500).send('Error processing request');
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
      }
    }
  }
});

module.exports = router;
