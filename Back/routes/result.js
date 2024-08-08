const express = require('express');
const PDFDocument = require('pdfkit');
const { ChartJSNodeCanvas } = require('chartjs-node-canvas');
const connectToOracle = require('../config/db'); 
const path = require('path');
const AuthToken = require('../AuthToken');
const fs = require('fs'); 

const router = express.Router();

async function getClobAsString(clob) {
  if (clob === null || clob === undefined) {
    console.error('CLOB data is null or undefined');
    return ' '; 
  }

  let clobString = '';
  
  try {
    // CLOB 데이터 스트림을 읽습니다.
    const lobStream = clob;
    let chunks = []; 

    lobStream.on('data', chunk => {
      chunks.push(chunk);
    });

    lobStream.on('end', () => {
      clobString = Buffer.concat(chunks).toString();
    });

    lobStream.on('error', error => {
      console.error('Error reading CLOB data:', error);
      throw error;
    });

    // 스트림이 끝날 때까지 기다립니다.
    await new Promise((resolve, reject) => {
      lobStream.on('end', resolve);
      lobStream.on('error', reject);
    });
  } catch (error) {
    console.error('Error processing CLOB data:', error);
    throw error;
  }

  return clobString;
}

// ECG 데이터를 전송하는 엔드포인트 추가
router.post('/ecg-data', AuthToken, async (req, res) => {
  const id = req.user.id;
  console.log("전송준비");
  let connection;
  try {
    connection = await connectToOracle();

    const result = await connection.execute(
        `SELECT ECG FROM TB_ANALYSIS WHERE ID = :id`,
        { id }
    );

    if (result.rows.length === 0) {
      return res.status(404).send('Analysis not found');
    }

    const ecgData = result.rows[0][0];
    res.json({ ecgData });
  } catch (error) {
    console.error('Error processing request:', error);
    res.status(500).send('Error processing request');
  } finally {
    if (connection) {
      console.log("전송준비완");
      try {
        await connection.close();
      } catch (err) {
        console.error('Error closing connection:', err);
      }
    }
  }
});

// ECG 그래프 생성 함수
async function generateECGChart(ecgData) {
  const width = 800;
  const height = 200;
  const chartJSNodeCanvas = new ChartJSNodeCanvas({ width, height });

  // x축 레이블을 1초마다 표시하도록 설정
  const labels = ecgData.map((_, index) => (index % 188 === 0 ? (index / 188).toFixed(0) : ''));

  const configuration = {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        data: ecgData,
        borderColor: 'rgba(255, 0, 0, 1)',
        borderWidth: 1,
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
          ticks: {
            autoSkip: false, 
            maxRotation: 0,
            callback: function(value, index, values) {
              return labels[index]; 
            }
          },
          title: {
            display: true,
            text: 'Time (seconds)',
          },
        },
        y: { 
          display: true,
          title: {
            display: true,
            text: 'Amplitude',
          },
        },
      },
      plugins: {
        legend: {
          display: false // 범례를 비활성화합니다.
        },
      },
    },
  };

  return await chartJSNodeCanvas.renderToBuffer(configuration);
}

/** 분석 결과를 pdf로 변환하고 다운로드 */
router.post('/downloadPdf',  AuthToken, async (req, res) => {
  const userId = req.user.id;
  const {analysisId} = req.body;
  console.log(analysisId)
  let connection;
  try {
    connection = await connectToOracle();
    const result = await connection.execute(
      `SELECT ID, BG_AVG, BP_MIN, BP_MAX, PR, QT, RR, QRS, CREATED_AT, ANALISYS_RESULT, ANALISYS_ETC, ECG
       FROM TB_ANALYSIS
       WHERE ANALYSIS_IDX = :analisys_idx`,
      { analisys_idx: analysisId}
    );
    

    if (result.rows.length === 0) {
      return res.status(404).send('Analysis not found');
    }

    const analysisData = result.rows[0];
    const [
      id,
      avgHeartRate,
      minHeartRate,
      maxHeartRate,
      pr,
      qt,
      rr,
      qrs, 
      analysisDate,
      ANALISYS_RESULT,
      ANALISYS_ETC,
      ecg
    ] = analysisData;

    
    // CLOB -> 문자열
    const analisysResultString = await getClobAsString(ANALISYS_RESULT);
    const analisysEtcString = await getClobAsString(ANALISYS_ETC);
    const ecgData = ecg.split(',').map(Number);

    const checkIconPath = path.join(__dirname, '../../Front/img/check.png'); 
    const reportIconPath = path.join(__dirname, '../../Front/img/report.png')
    const boldFontPath = path.join(__dirname, '../../Front/fonts/NanumGothicBold.ttf');

    // pdf 만들기
    const doc = new PDFDocument({ size: 'A4',  margin: 50 });
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
      fs.writeFileSync(filePath, pdfBuffer); // PDF 파일을 서버의 로컬 디렉토리에 저장
      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader('Content-Disposition', 'attachment; filename=analysis.pdf');
      res.send(pdfBuffer);
    });

    // pdf 내용
    doc.fontSize(20).fillColor('black').text(`${id}님 리포트`, { align: 'center' });
    doc.moveDown();

    doc.fontSize(14).fillColor('black').text(`검사 일시: ${new Date(analysisDate).toLocaleString()}`, { align: 'center' });
    doc.moveDown();
    doc.moveDown();

    // ECG 그래프 추가
    try {
      const ecgChartBuffer = await generateECGChart(ecgData);
      const pageWidth = doc.page.width - doc.page.margins.left - doc.page.margins.right;
      const imageHeight = 200; // 원하는 이미지 높이
      doc.image(ecgChartBuffer, doc.page.margins.left, doc.y, {
        fit: [pageWidth, imageHeight], // 이미지 크기를 페이지 너비에 맞게 조정
        align: 'center' // 가운데 정렬
      });
      doc.moveDown(10);
    } catch (err) {
      console.error('Error generating ECG chart:', err);
    }

    doc.image(reportIconPath, doc.x, doc.y, {width: 25});

    doc.font('NanumGothicBold')
   .fontSize(20)
   .fillColor('red')
   .text(' 검사결과', doc.x + 25, doc.y);
    doc.moveDown(1.5);

    // 검사결과 심박수 및 산소포화도
    // 아이콘을 그립니다.
    doc.image(checkIconPath, doc.x, doc.y, {width: 15});

    // 아이콘의 높이를 계산합니다.
    const iconHeight = 15; // 아이콘의 높이 (픽셀)

    // 텍스트의 y 좌표를 아이콘의 y 좌표와 일치하게 조정합니다.
    // 텍스트의 y 좌표는 아이콘의 중앙에 맞추기 위해 조정됩니다.
    let textY = doc.y + (iconHeight - 16) / 2 - 2; // 16은 텍스트의 폰트 크기
    let startX = doc.x

    doc.font('NanumGothicBold')
   .fontSize(16)
   .fillColor('black')
   .text('심박수', doc.x + 25, textY);
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(`평균 심박수: ${avgHeartRate} BPM`);
    doc.text(`최저 심박수: ${minHeartRate} BPM`);
    doc.text(`최고 심박수: ${maxHeartRate} BPM`);
    doc.moveDown(2);


    // 산소포화도 위치 조정
    doc.moveDown(); // 심박수와 산소포화도 사이의 간격을 추가
    doc.image(checkIconPath, startX, doc.y, { width: 15 }); // 저장된 x 좌표를 사용
    textY = doc.y + (iconHeight - 16) / 2 - 2; // 새로운 textY 계산
    doc.font('NanumGothicBold')
        .fontSize(16)
        .fillColor('black')
        .text('산소포화도', startX + 25, textY); // 저장된 x 좌표를 기준으로 텍스트 위치 계산
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(`HRV: ${rr} %`);
    doc.moveDown(2);

    // 심전도 섹션의 시작 좌표 설정
    const saveX = doc.x;
    const saveY = doc.y;

    // 심전도
    doc.x = saveX + 250; // 심전도를 오른쪽으로 이동
    doc.y = saveY - 193;

    textY = doc.y + (iconHeight - 16) / 2 - 2; 

    doc.image(checkIconPath, doc.x - 25, doc.y, { width: 15 });
    doc.font('NanumGothicBold')
        .fontSize(16)
        .fillColor('black')
        .text('심전도', doc.x, textY)

    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(`PR Interval: ${pr} ms`);
    doc.text(`QT Interval: ${qt} ms`);
    doc.text(`RR Interval: ${rr} ms`);
    doc.text(`QRS Interval: ${qrs} ms`);
    doc.moveDown(2);

    // 분석 결과 및 메모
    doc.x = saveX; // X 좌표를 처음으로 되돌림
    doc.y = saveY + 10; // Y 좌표를 아래로 이동

    doc.image(checkIconPath, startX, doc.y, { width: 15 }); 
    textY = doc.y + (iconHeight - 16) / 2 - 2; 

    doc.font('NanumGothicBold')
        .fontSize(16)
        .fillColor('black')
        .text('분석 결과', doc.x, textY);
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(analisysResultString);
    doc.moveDown(2);

    doc.image(checkIconPath, startX, doc.y, { width: 15 }); 
    textY = doc.y + (iconHeight - 16) / 2 - 2; 

    doc.font('NanumGothicBold')
        .fontSize(16)
        .fillColor('black')
        .text('분석 메모', doc.x, textY);
    doc.moveDown();
    doc.font('NanumGothic').fontSize(12).text(analisysEtcString);

    doc.end();
  } catch (error) {
    console.error('Error processing request:', error);
    res.status(500).send('Error processing request');
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error('Error closing connection:', err);
      }
    }
  }
});

module.exports = router;
