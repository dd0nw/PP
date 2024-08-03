const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const connectToOracle = require("../config/db");
const jwtSecret = process.env.JWT_SECRET;
const cryptoSecret = process.env.CRYPTO_SECRET;

/////////////////////////////////////////
let tokenStore = ''; // 토큰을 저장할 메모리 저장소
///////////////////////////////////////////

/** 암호화 함수 AES-256-CBC 알고리즘 사용*/
function encrypt(text) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(
    "aes-256-cbc",
    Buffer.from(cryptoSecret, "hex"),
    iv
  );
  let encrypted = cipher.update(text, "utf8", "hex");
  encrypted += cipher.final("hex");
  return iv.toString("hex") + ":" + encrypted;
}

/** 로그인 */
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
        const pwpw = bcrypt.compareSync(pw, user[1]);
        console.log(pw, user[1]);
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
        ///////////////////
        tokenStore = token; //로그인할때 전달 토큰 변수에 토큰 할당
        ////////////////////
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

/** 회원가입 */
router.post("/register", async (req, res) => {
  const { id, pw, name, birth, gender, height, weight, heartRate } = req.body;

  // 비밀번호 암호화
  const hashedPw = bcrypt.hashSync(pw, 10);

  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        `INSERT INTO TB_USER (ID, PW, NAME, BIRTHDATE, GENDER, HEIGHT, WEIGHT, PULSE, JOINED_AT)
         VALUES (:id, :password, :name, TO_DATE(:birth, 'YYYY-MM-DD'), :gender, :height, :weight, :heartrate, sysdate)`,
        {
          id,
          password: hashedPw,
          name: name,
          birth: birth,
          gender: gender,
          height: height,
          weight: weight,
          heartrate: heartRate,
        }
      );
      await connection.commit();
      res.status(200).send({ auth: true });
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    } finally {
      await connection.close();
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});
///////////////////////////////////////////////
router.get('/get-token', (req, res) => {
  console.log("토큰전달준비완료");
  if (!tokenStore) {
    return res.status(400).json({ error: 'Token not found' });
  }
  res.json({ token: tokenStore });
}); //일단은 로그인 html로해서 session storage에 저장한뒤 토큰 전달하는 엔드포인트
////////////////////////////////////////////////

module.exports = router;
