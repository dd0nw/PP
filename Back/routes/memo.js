const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");
let MemoContent = []; //메모를 저장할 변수
let variable = 0; // 상태를 저장할 변수
let lastRowCount = 0; // 계속 반복 안되게 할 변수

/** 메모 수정 및 정보 불러오기 */
router.post("/memo", AuthToken, async (req, res) => {
  const id = req.user.id;
  const content = req.body.ANALISYS_ETC;
  MemoContent = content;
  const analysisId = req.body.ANALYSIS_IDX;
  console.log(content, MemoContent);
  const connection = await connectToOracle();
  if (connection) {
    try {
      // 메모 업데이트 쿼리 실행
      await connection.execute(
        "UPDATE TB_ANALYSIS SET ANALISYS_ETC = :content WHERE ID = :id AND ANALYSIS_IDX = :analysisId",
        { content: content, id: id, analysisId: analysisId },
        { autoCommit: true }
      );
      console.log("메모수정완료", content, id);

      // 성공 응답 반환
      res.status(200).json({ ANALISYS_ETC: MemoContent });
    } catch (error) {
      console.error("Error:", error);
      res.status(500).send("Error executing query");
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (err) {
          console.error("Error closing connection:", err);
        }
      }
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** 메모 조회 */
router.get("/memo", AuthToken, async (req, res) => {
  const id = req.user.id;
  res.status(200).json({ memos: [{ ANALISYS_ETC: MemoContent }] });
});

//서버1
/** 데이터베이스 조회 및 변수 업데이트 */
router.get("/check", async (req, res) => {
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT COUNT(*) AS count FROM tb_analysis"
      );
      const currentRowCount = result.rows[0][0];
      console.log(lastRowCount);
      console.log(currentRowCount);
      console.log(variable);
      if (currentRowCount > 0 && currentRowCount !== lastRowCount) {
        variable++;
        console.log("check", variable);
        console.log(`Variable incremented to ${variable}`);
        lastRowCount = currentRowCount; // Update lastRowCount
      }
      console.log("알림 되려나");
      res.json({ variable });
    } catch (error) {
      console.error("Error querying database:", error);
      res.status(500).send("Error querying database");
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (err) {
          console.error("Error closing connection:", err);
        }
      }
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** /status 엔드포인트 */
router.get("/status", (req, res) => {
  console.log("자동 확인용1");
  res.json({ variable });
  console.log("status", variable);
});

module.exports = router;
