const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

async function getClobAsString(clob) {
  if (clob === null || clob === undefined) {
    console.error("CLOB data is null or undefined");
    return " ";
  }

  let clobString = "";

  try {
    // CLOB 데이터 스트림을 읽습니다.
    const lobStream = clob;
    let chunks = [];

    lobStream.on("data", (chunk) => {
      chunks.push(chunk);
    });

    lobStream.on("end", () => {
      clobString = Buffer.concat(chunks).toString();
    });

    lobStream.on("error", (error) => {
      console.error("Error reading CLOB data:", error);
      throw error;
    });

    // 스트림이 끝날 때까지 기다립니다.
    await new Promise((resolve, reject) => {
      lobStream.on("end", resolve);
      lobStream.on("error", reject);
    });
  } catch (error) {
    console.error("Error processing CLOB data:", error);
    throw error;
  }

  return clobString;
}

/** 부정맥 발생 의심 목록 불러오기 */
// 데이터 날짜 거꾸로 정렬해야함
router.post("/analysis", AuthToken, async (req, res) => {
  const id = req.user.id;
  const date = req.body.createdAt;
  const connection = await connectToOracle();
  console.log(req.body);
  //console.log(`Received request with id: ${id} and date: ${date}`); //
  //console.log(req.body.createdAt);
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT analysis_idx, id, bg_avg,TO_CHAR(created_at, 'HH24:MI:SS') as created_at, pr, qt, rr, qrs, ANALISYS_RESULT FROM tb_analysis WHERE TO_CHAR(CREATED_AT, 'YYYY/MM/DD')=(:create_at) and ID=:id ORDER BY CREATED_AT DESC",

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
          //DATE: row[4],
          PR: row[4],
          QT: row[5],
          RR: row[6],
          QRS: row[7],
          ANALISYS_RESULT: await getClobAsString(row[8]), // CLOB 변환
        };
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
router.post("/analysisResult", AuthToken, async (req, res) => {
  const id = req.user.id;
  const date = req.body.createdAt;
  const connection = await connectToOracle();
  console.log(`Received request22222 with id: ${id} and date: ${date}`);
  console.log(req.body);

  try {
    const result = await connection.execute(
      `SELECT bg_avg, bp_min, bp_max, pr, qt, rr, qrs, analisys_result, analisys_etc, ecg FROM TB_ANALYSIS WHERE ID = :id AND CREATED_AT = TO_DATE(:createdAt, 'YYYY/MM/DD HH24:MI:SS')`,
      { id: id, createdAt: date }
    );

    console.log(result.rows[0]);
    if (result.rows.length > 0) {
      const [
        bg_avg,
        bp_min,
        bp_max,
        pr,
        qt,
        rr,
        qrs,
        analisys_result,
        analisys_etc,
        ecg,
      ] = result.rows[0];

      const analisysResultString = await convertClobToString(analisys_result);
      const analisysEtcString = await convertClobToString(analisys_etc);

      res.status(200).json({
        bg_avg,
        bp_min,
        bp_max,
        pr,
        qt,
        rr,
        qrs,
        analisys_result: analisysResultString,
        analisys_etc: analisysEtcString,
        ecg,
      });
    } else {
      res.status(404).json({ message: "No data found" });
    }
  } catch (error) {
    console.error("Error executing query:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
