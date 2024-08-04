const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

/** 부정맥 발생 의심 목록 불러오기 */
// 데이터 날짜 거꾸로 정렬해야함
router.post("/analysis", AuthToken, async (req, res) => {
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

module.exports = router;
