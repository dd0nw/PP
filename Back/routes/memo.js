const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");


/** 메모 수정 및 정보 불러오기 */

/** 메모 수정 */

router.post("/memo", AuthToken, async (req, res) => {
  const id = req.user.id;
  const  memoContent  =req.body.ANALISYS_ETC; //flutter
  // const { memoContent } = req.bod // html
  
  const connection = await connectToOracle();
  if (connection) {
    try {
      console.log("id",id,"memo content",memoContent);
      await connection.execute(
        "UPDATE TB_ANALYSIS SET ANALISYS_ETC = :memoContent WHERE ID = :id",
        { memoContent, id },
        { autoCommit: true }
      );
      const result = await connection.execute(
        "SELECT ANALISYS_ETC FROM TB_ANALYSIS WHERE ID = :id",
        { id }
      );

      if (result.rows.length > 0) {
        const clob = result.rows[0][0];
        if (clob) {
          let memo = '';

          clob.setEncoding('utf8');
          clob.on('data', (chunk) => {
            memo += chunk;
          });

          clob.on('end', async () => {
            res.status(200).json({ ANALISYS_ETC: memo });
            await connection.close(); // 여기서 연결을 닫습니다.
          });

          clob.on('error', async (err) => {
            console.error('Error reading CLOB:', err);
            res.status(500).send('Error reading CLOB');
            await connection.close(); // 여기서 연결을 닫습니다.
          });
        } else {
          console.error('CLOB object is null');
          res.status(404).json({ message: "No memo found for this ID" });
          await connection.close();
        }
      } else {
        res.status(404).json({ message: "No memo found for this ID" });
        await connection.close();
      }
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
      await connection.close(); // 여기서 연결을 닫습니다.
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
          let memo = '';

          clob.setEncoding('utf8');
          clob.on('data', (chunk) => {
            memo += chunk;
          });

          clob.on('end', async () => {
            res.status(200).json({ memos: [{ ANALISYS_ETC: memo }] });
            await connection.close(); // 여기서 연결을 닫습니다.
          });

          clob.on('error', async (err) => {
            console.error('Error reading CLOB:', err);
            res.status(500).send('Error reading CLOB');
            await connection.close(); // 여기서 연결을 닫습니다.
          });
        } else {
          console.error('CLOB object is null');
          res.status(200).json({ memos: [] });
          await connection.close();
        }
      } else {
        res.status(404).json({ message: "No memo found for this ID" });
        await connection.close();
      }
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
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
      // 메모 정보 조회 쿼리
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
