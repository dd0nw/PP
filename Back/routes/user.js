const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const connectToOracle = require("../config/db");
const { sendEmail } = require('../config/email');
const { autoCommit } = require("oracledb");
const jwtSecret = process.env.JWT_SECRET;
const cryptoSecret = process.env.CRYPTO_SECRET;

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


/** 이메일 코드 전송(중복 검사) */
router.post('/snedEmail', async (req, res) => {
  const {email} = req.body;
  const code = crypto.randomBytes(3).toString('hex');
  try {
    const connection = await db.connectToOracle();
    const sql = 'SELECT ID FROM TB_USER WHERE ID = :email';
    
    const result = await connection.execute(sql, [email]);

    if (result.rows.length > 0) {
      await connection.close();
      return res.json({success : false, message: 'exist email'})
    } else {
      const result = await connection.execute(
        `SELECT CREATED_AT FROM VERIFICATION_CODES WHERE ID = :eamil`,
        { email : email }
      );

      const now = new Date();
      if (result.rows.length > 0) {
        const lastRequestTime = result.rows[0][0];
        const diffMinutes = (now - lastRequestTime) / 60000;
        if (diffMinutes < 1) {
          return res. status(429).send("너무 많은 요청");
        }
      }

      await connection.execute(
        `MERGE INTO verification_codes vc
         USING (SELECT :email AS email FROM dual) d
         ON (vc.email = d.email)
         WHEN MATCHED THEN
         UPDATE SET code = :code, created_at = :now, expires_at = :expires_at
         WHEN NOT MATCHED THEN
         INSERT (email, code, created_at, expires_at)
         VALUES (:email, :code, :now, :expires_at)`,
      {
        email: email,
        code: verificationCode,
        now: now,
        expires_at: new Date(now.getTime() + 5 * 60000)
      },
      {autoCommit: true}
      );
      connection.close();

      const mailOptions = {
        from : 'g8793173@gmail.com',
        to: email,
        subject: 'PULSEPULSE 인증 코드',
        text: `인증코드는 ${code} 입니다.`
      };

      transporter.sendEmail(mailOptions, (error, info) =>{
        if(error) {
          return res.status(500).send(error.toString());
        }
        res.status(200).send("이메일 전송: " + info.response);
      });
    } 

  } catch(error) {
    res.status(500).json({success:false, message: '코드 전송 실패', error : error.message});
  }
});

/** 코드 확인 */
router.post('/verifyCode', async(req, res) => {
  const {email, code} = req.body;
  try {
    const connection = await oracleDB.getConnection();
    const result = await connection.execute(
      `SELECT CODE FROM VERIFICATION_CODES WHERE EMAIL = : eamil AND CODE = :code AND EXPIRES_AT > CURRENT_TIMESTAMP`,
      {email: email, code: code}
    );
    connection.close();

    if (result.rows.length > 0) {
      res.status(200).send('코드 전송 성공');
    } else {
      res.status(400).send('코드 전송 실패');
    }
  } catch(err) {
    console.error('디비 오류', err);
    res.status(500).send('db 오류');
  }
});

/** 아이디 찾기 */
router.post('/findId', async (req, res) => {
  const {name, birthday} = req.body;
  try {
    const connection = await oracleDB.getConnection();
    const result = await connection.execute(
      `SELECT id FROM TB_USER WHERE NAME= :name AND BIRTHDAT = :birthday`,
      {name: name, birthday: birthday}
    );
    connection.close();

    if(result.rows.length > 0 ) {
      res.json({success: true, id: result.rows[0].ID});
    } else {
      res.json({success: false, message: '일치하는 사용자가 없습니다'});
    }

  } catch (error){
      res.status(500).json({success: false, message: '아이디 찾기 실패'})
  }
})

/** 비밀번호 찾기 */
router.post('/findPw', async(req, res) => {
  
})

module.exports = router;
