const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const connectToOracle = require("../config/db");
const jwtSecret = process.env.JWT_SECRET;
const cryptoSecret = process.env.CRYPTO_SECRET;
const AuthToken = require('../AuthToken');
const {disconnectKakao} = require('../passport/disconnectKakao');
const { kakaoAccessTokenStore } = require('../passport/kakaoStrategy');

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
}); //session storage에 저장한뒤 토큰 전달하는 엔드포인트
////////////////////////////////////////////////

// 로그아웃
router.post('/logout', AuthToken, async (req, res) => {
  console.log("Logging out");
  const userId = req.user.id;
  
  // 메모리 저장소에서 액세스 토큰 가져오기
  const accessToken = kakaoAccessTokenStore[userId];

  // 카카오 소셜 로그아웃 처리
  try {
    if (accessToken) {
      console.log("진행중");
      await disconnectKakao(accessToken); // 카카오 언링크 함수 호출
      console.log("Kakao user logged out");
    }
  } catch (error) {
    console.error("Error logging out from Kakao:", error.message);
  }

  // 토큰 저장소 초기화
  tokenStore = ''; // 메모리 저장소에서 JWT 토큰 삭제
  delete kakaoAccessTokenStore[userId]; // 메모리 저장소에서 액세스 토큰 삭제
  
  res.status(200).send({ auth: false, token: null, message: "Logged out" });
});


/** 회원탈퇴 */
router.post("/delete-account", AuthToken, async (req, res) => {
  const userId = req.user.id; // 토큰에서 추출한 사용자 ID
  const connection = await connectToOracle();
  if (connection) {
    try {

      // 사용자 정보 삭제 전 관련된 데이터 삭제
      await connection.execute(
        "DELETE FROM TB_ALARM WHERE ID = :id",
        { id: userId }
      );
      await connection.execute(
        "DELETE FROM TB_METADATA WHERE ID = :id",
        { id: userId }
      );
      await connection.execute(
        "DELETE FROM VERIFICATION_CODES WHERE ID = :id",
        { id: userId }
      );
      await connection.execute(
        "DELETE FROM TB_ANALYSIS WHERE ID = :id",
        { id: userId }
      );

      // 사용자 정보 삭제
      const result = await connection.execute(
        "DELETE FROM TB_USER WHERE ID = :id",
        { id: userId }
      );

      await connection.commit(); // 변경 사항 커밋
      tokenStore = ''; // 메모리 저장소에서 토큰 삭제

      res.status(200).send({ message: "Account deleted successfully" });
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    } finally {
      await connection.close(); // 연결 종료
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** Get Token */
router.get('/get-token', (req, res) => {
  console.log("토큰전달준비완료");
  if (!tokenStore) {
    return res.status(400).json({ error: 'Token not found' });
  }
  res.json({ token: tokenStore });
});

module.exports = router;