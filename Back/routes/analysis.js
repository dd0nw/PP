const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

async function convertClobAsString(lob) {
  return new Promise((resolve, reject) => {
    if (lob === null) {
      return resolve(null);
    }

    let clobString = '';

    lob.setEncoding('utf8');  // 인코딩을 설정합니다.

    lob.on('data', (chunk) => {
      clobString += chunk;  // 스트림 데이터를 읽어와 문자열로 결합합니다.
    });

    lob.on('end', () => {
      resolve(clobString);  // 모든 데이터를 읽은 후 문자열을 반환합니다.
    });

    lob.on('error', (err) => {
      reject(err);  // 오류 발생 시 Promise를 거부합니다.
    });
  });
}


/** 부정맥 발생 의심 목록 불러오기 */
router.post("/analysis", AuthToken, async (req, res) => {
  const id = req.user.id;
  const date = req.body.createdAt;
  const connection = await connectToOracle();
  console.log(req.body);
  if (connection) {
    try {
      const result = await connection.execute(
        `SELECT 
          analysis_idx, 
          id, 
          bg_avg,
          TO_CHAR(created_at, 'HH24:MI:SS') as created_at, 
          TO_CHAR(created_at, 'YYYY/MM/DD HH24:MI:SS') AS fulldate, 
          pr, 
          qt, 
          rr, 
          qrs, 
          ANALISYS_RESULT,
          ANALISYS_ETC,
          ECG 
        FROM tb_analysis 
        WHERE TO_CHAR(CREATED_AT, 'YYYY/MM/DD')=(:create_at) AND ID=:id 
        ORDER BY CREATED_AT DESC`,

        { create_at: date, id: id }
      );

      const rows = result.rows;
      const convertedRows = [];

      for (let row of rows) {
        const convertedRow = {
          ANALYSIS_IDX: row[0],
          ID: row[1],
          BG_AVG: row[2],
          CREATED_AT: row[3],
          FULLDATE: row[4],
          PR: row[4],
          QT: row[5],
          RR: row[6],
          QRS: row[7],
          ANALISYS_RESULT: row[8],
          ANALISYS_ETC : await convertClobAsString(row[9]),
          ECG : await convertClobAsString(row[10])
        };
        console.log(convertedRow)
        convertedRows.push(convertedRow);
      }
      
      
      res.status(200).json(convertedRows);
      console.log(convertedRows);
      await connection.close();
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** 부정맥 결과지 */
router.post('/analysisResult', AuthToken, async(req, res) => {
  const createdAt = req.body.createdAt;
  const id = req.user.id;
  const connection = await connectToOracle();
  console.log(createdAt, id)

  try {
    const result = await connection.execute(
      `SELECT bg_avg, bp_min, bp_max, pr, qt, qr, rr, qrs, analisys_result, analisys_etc, ecg FROM TB_ANALYSIS WHERE ID = :id AND CREATED_AT = :createdAt`,
      {id: id, createdAt: createdAt}
    );
    if (result.rows.length > 0) {
      const [bg_avg, bp_min, bp_max, pr, qt, qr, rr, qrs, analisys_result, analisys_etc, ecg] = result.rows[0];
  
      const analisysResultString = await convertClobToString(analisys_result);
      const analisysEtcString = await convertClobToString(analisys_etc);
  
      res.status(200).json({
        bg_avg,
        bp_min,
        bp_max,
        pr,
        qt,
        qr,
        rr,
        qrs,
        analisys_result: analisysResultString,
        analisys_etc: analisysEtcString,
        ecg
      });
    } else {
      res.status(404).json({ message: 'No data found' });
    }
  } catch (error) {
    console.error('Error executing query:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

module.exports = router;
