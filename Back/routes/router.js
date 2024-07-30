// 라우트
const express = require("express");
const router = express.Router();
const oracledb = require("oracledb");
const jwt = require("jsonwebtoken");
const AuthToken = require("../AuthToken");
// const bcrypt = require("bcryptjs");

const jwtSecret = process.env.JWT_SECRET;

const dbConfig = {
  user: "cgi_24S_IoT3_1",
  password: "smhrd1",
  connectString: "project-db-cgi.smhrd.com:1524/xe",
};

async function connectToOracle() {
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log("Successfully connected to Oracle database");
    await connection.execute(`ALTER SESSION SET TIME_ZONE='UTC'`);
    return connection;
  } catch (err) {
    console.error("Connection failed: ", err);
  }
}

router.get("/", async (req, res) => {
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(`SELECT SYSDATE FROM DUAL`);
      res.send(`Current date and time: ${result.rows[0]}`);
      await connection.close();
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

router.post("/login", async (req, res) => {
  const { id, pw } = req.body;
  console.log(id, pw);
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT * FROM TB_USER WHERE ID = :id",
        { id }
      );
      if (result.rows.length > 0) {
        const user = result.rows[0];
        // const pwpw = bcrypt.compareSync(pw, user[1]);
        const pwpw = user[1] == pw;
        console.log(pwpw, user[1]);
        if (!pwpw) {
          return res
            .status(401)
            .send({ auth: false, token: null, message: "Invalid password" });
        }
        const token = jwt.sign({ id: user[0] }, jwtSecret, {
          expiresIn: 86400,
        });
        console.log(token);
        res.status(200).send({ auth: true, token: token });
      } else {
        res.status(404).send("No user found");
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

router.get("/analysis", AuthToken, async (req, res) => {
  const id = req.user.id; // 토큰에서 추출한 사용자 ID
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        "SELECT * FROM TB_ANALYSIS WHERE ID = :id",
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
