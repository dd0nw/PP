const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

/** 메모 수정 및 정보 불러오기 */
router.post("/memo", AuthToken, async (req, res) => {
  console.log(AuthToken);
  const id = req.user.id;
  const { memoContent } = req.body; // 프론트엔드에서 memoContent를 전송해야 함
  const connection = await connectToOracle();
  if (connection) {
    try {
      // 메모 업데이트 쿼리
      await connection.execute(
        "UPDATE TB_ANALYSIS SET ANALISYS_ETC = :memoContent WHERE ID = :id",
        { memoContent, id },
        { autoCommit: true } // 업데이트 후 커밋
      );
      // 업데이트된 메모 정보 조회 쿼리
      const result = await connection.execute(
        "SELECT ANALISYS_ETC FROM TB_ANALYSIS WHERE ID = :id",
        { id }
      );
      if (result.rows.length > 0) {
        const memo = result.rows[0][0]; // 첫 번째 행의 첫 번째 열 데이터
        res.status(200).json({ ANALISYS_ETC: memo });
      } else {
        res.status(404).json({ message: "No memo found for this ID" });
      }
      await connection.close();
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

module.exports = router;
