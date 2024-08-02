const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

/** 분석 결과 불러오기 */
router.get("/", AuthToken, async (req, res) => {
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
