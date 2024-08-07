const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

async function convertClobToString(clob) {
  return new Promise((resolve, reject) => {
    let clobData = '';
    clob.setEncoding('utf8');
    clob.on('data', (chunk) => {
      clobData += chunk;
    });
    clob.on('end', () => {
      resolve(clobData);
    });
    clob.on('error', (err) => {
      reject(err);
    });
  });
}

/** 부정맥 발생 의심 목록 불러오기 */
// 데이터 날짜 거꾸로 정렬해야함
router.get("/analysis", AuthToken, async (req, res) => {
  const id = req.user.id;
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT * FROM TB_ANALYSIS WHERE ID = :id ORDER BY CREATED_AT DESC",
        { id }
      );
      res.status(200).json(result.rows);
      console.log(result.rows);
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
