const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");

/** 메모 수정 및 정보 불러오기 */
router.post("/memo", AuthToken, async (req, res) => {
  const id = req.user.id;
  const { memoContent, analysis_idx } = req.body;

  const connection = await connectToOracle();
  if (connection) {
    try {
      await connection.execute(
        "UPDATE TB_ANALYSIS SET ANALISYS_ETC = :memoContent WHERE ID = :id AND ANALYSIS_IDX = :analysis_idx",
        { memoContent, id, analysis_idx },
        { autoCommit: true }
      );
      console.log("메모수정완료", memoContent, id, analysis_idx);
      const result = await connection.execute(
        "SELECT ANALISYS_ETC FROM TB_ANALYSIS WHERE ID = :id",
        { id }
      );
      console.log("수정후 바뀐거", result);
      if (result.rows.length > 0) {
        const clob = result.rows[0][0];
        if (clob) {
          let memo = "";

          clob.setEncoding("utf8");
          clob.on("data", (chunk) => {
            memo += chunk;
          });

          clob.on("end", async () => {
            res.status(200).json({ ANALISYS_ETC: memo });
            await connection.close();
          });

          clob.on("error", async (err) => {
            res.status(500).send("Error reading CLOB");
            await connection.close();
          });
        } else {
          res.status(404).json({ message: "No memo found for this ID" });
          await connection.close();
        }
      } else {
        res.status(404).json({ message: "No memo found for this ID" });
        await connection.close();
      }
    } catch (err) {
      res.status(500).send("Error executing query");
      await connection.close();
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** 메모 조회 */
router.get("/memo", AuthToken, async (req, res) => {
  const id = req.user.id;
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT ANALISYS_ETC FROM TB_ANALYSIS WHERE ID = :id",
        { id }
      );

      if (result.rows.length > 0) {
        const clob = result.rows[0][0];
        if (clob) {
          let memo = "";

          clob.setEncoding("utf8");
          clob.on("data", (chunk) => {
            memo += chunk;
          });

          clob.on("end", async () => {
            res.status(200).json({ memos: [{ ANALISYS_ETC: memo }] });
            await connection.close();
          });

          clob.on("error", async (err) => {
            res.status(500).send("Error reading CLOB");
            await connection.close();
          });
        } else {
          res.status(200).json({ memos: [] });
          await connection.close();
        }
      } else {
        res.status(404).json({ message: "No memo found for this ID" });
        await connection.close();
      }
    } catch (err) {
      res.status(500).send("Error executing query");
      await connection.close();
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** 메모 조회 */
router.get("/memo", AuthToken, async (req, res) => {
  const id = req.user.id;
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT ANALISYS_ETC FROM TB_ANALYSIS WHERE ID = :id",
        { id }
      );

      if (result.rows.length > 0) {
        const clob = result.rows[0][0];
        if (clob) {
          let memo = "";

          clob.setEncoding("utf8");
          clob.on("data", (chunk) => {
            memo += chunk;
          });

          clob.on("end", async () => {
            res.status(200).json({ memos: [{ ANALISYS_ETC: memo }] });
            await connection.close();
          });

          clob.on("error", async (err) => {
            res.status(500).send("Error reading CLOB");
            await connection.close();
          });
        } else {
          res.status(200).json({ memos: [] });
          await connection.close();
        }
      } else {
        res.status(404).json({ message: "No memo found for this ID" });
        await connection.close();
      }
    } catch (err) {
      res.status(500).send("Error executing query");
      await connection.close();
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

module.exports = router;
