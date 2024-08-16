const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const connectToOracle = require("../config/db");
const { sendmail } = require("../config/email");
const AuthToken = require("../AuthToken");

const jwtSecret = process.env.JWT_SECRET;
const cryptoSecret = process.env.CRYPTO_SECRET;
const { disconnectKakao } = require("../passport/disconnectKakao");
const { kakaoAccessTokenStore } = require("../passport/kakaoStrategy");

/////////////////////////////////////////
let tokenStore = ""; // 토큰을 저장할 메모리 저장소
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
        if (!pwpw) {
          return res
            .status(401)
            .json({ auth: false, token: null, message: "Invalid password" });
        }
        const token = jwt.sign({ id: user[0] }, jwtSecret, {
          expiresIn: 86400,
        });
        ///////////////////
        tokenStore = token; //로그인할때 전달 토큰 변수에 토큰 할당
        ////////////////////
        res.status(200).send({ auth: true, token: token });
      } else {
        res.status(404).json("No user found");
      }
      await connection.close();
    } catch (err) {
      res.status(500).send("Error executing query");
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** 회원가입 */
router.post("/register", async (req, res) => {
  const { id, pw, name } = req.body;

  // 비밀번호 암호화
  const hashedPw = bcrypt.hashSync(pw, 10);

  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(
        `INSERT INTO TB_USER (ID, PW, NAME, BIRTHDATE, GENDER, HEIGHT, WEIGHT, PULSE, JOINED_AT)
         VALUES (:id, :password, :name, sysdate, '0', 0, 0, 0, sysdate)`,
        {
          id,
          password: hashedPw,
          name: name,
        },
        { autoCommit: true }
      );
      res.status(200).json({ auth: true });
    } catch (err) {
      res.status(500).json({ message: "Error executing query" });
    } finally {
      await connection.close();
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

///////////////////////////////////////////////
router.get("/get-token", (req, res) => {
  console.log("토큰전달준비완료");
  if (!tokenStore) {
    return res.status(400).json({ error: "Token not found" });
  }
  res.json({ token: tokenStore });
}); //session storage에 저장한뒤 토큰 전달하는 엔드포인트
////////////////////////////////////////////////

// 로그아웃
router.post("/logout", AuthToken, async (req, res) => {
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
  } catch (error) {}

  // 토큰 저장소 초기화
  tokenStore = ""; // 메모리 저장소에서 JWT 토큰 삭제
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
      await connection.execute("DELETE FROM TB_ALARM WHERE ID = :id", {
        id: userId,
      });
      await connection.execute("DELETE FROM TB_METADATA WHERE ID = :id", {
        id: userId,
      });
      await connection.execute(
        "DELETE FROM VERIFICATION_CODES WHERE ID = :id",
        { id: userId }
      );
      await connection.execute("DELETE FROM TB_ANALYSIS WHERE ID = :id", {
        id: userId,
      });

      // 사용자 정보 삭제
      const result = await connection.execute(
        "DELETE FROM TB_USER WHERE ID = :id",
        { id: userId }
      );

      await connection.commit(); // 변경 사항 커밋
      tokenStore = ""; // 메모리 저장소에서 토큰 삭제

      res.status(200).send({ message: "Account deleted successfully" });
    } catch (err) {
      res.status(500).send("Error executing query");
    } finally {
      await connection.close(); // 연결 종료
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/** Get Token */
router.get("/get-token", (req, res) => {
  console.log("gettoken");
  if (!tokenStore) {
    return res.status(400).json({ error: "Token not found" });
  }
  console.log("token");
  res.json({ token: tokenStore });
});

/** 이메일 코드 전송(중복 검사 포함) */
router.post("/checkId", async (req, res) => {
  const { email } = req.body;
  const code = crypto.randomBytes(3).toString("hex");

  const mailOptions = {
    to: email,
    subject: "PULSEPULSE 인증 코드",
    text: `인증코드는 ${code} 입니다.`,
  };

  try {
    const connection = await connectToOracle();

    await connection.execute(
      `DELETE FROM tb_verification_codes WHERE EXPIRES_AT <= CURRENT_TIMESTAMP`,
      [],
      { autoCommit: true }
    );

    const result = await connection.execute(
      `SELECT * FROM TB_USER WHERE ID = :id`,
      { id: email }
    );

    const now = new Date();

    if (result.rows.length > 0) {
      await connection.close();
      return res.status(500).json({ message: "이미 존재하는 이메일" });
    } else {
      await connection.execute(
        `MERGE INTO tb_verification_codes vc
         USING (SELECT :id AS id FROM dual) d
         ON (vc.id = d.id)
         WHEN MATCHED THEN
         UPDATE SET code = :code, created_at = :now, expires_at = :expires_at
         WHEN NOT MATCHED THEN
         INSERT (id, code, created_at, expires_at)
         VALUES (:id, :code, :now, :expires_at)`,
        {
          id: email,
          code: code,
          now: now,
          expires_at: new Date(now.getTime() + 5 * 60000),
        },
        { autoCommit: true }
      );

      // 이메일 전송
      await connection.close();

      try {
        const emailResponse = await sendmail(
          mailOptions.to,
          mailOptions.subject,
          mailOptions.text
        );
        res.status(200).json({
          message: "이메일 전송 성공",
          response: emailResponse.response,
        });
      } catch (error) {
        res
          .status(500)
          .json({ message: "이메일 전송 실패", error: error.toString() });
      }
    }
  } catch (err) {
    res.status(500).json({ error: err, message: "Error occurred" });
  }
});

/** 코드 확인 */
router.post("/verifyCode", async (req, res) => {
  const { email, code } = req.body;
  try {
    const connection = await connectToOracle();
    const result = await connection.execute(
      `SELECT CODE FROM TB_VERIFICATION_CODES WHERE ID = :id AND CODE = :code AND EXPIRES_AT > CURRENT_TIMESTAMP`,
      { id: email, code: code }
    );
    connection.close();

    if (result.rows.length > 0) {
      res.status(200).send("인증 성공");
    } else {
      res.status(400).send("인증 실패");
    }
  } catch (err) {
    res.status(500).send("db 오류");
  }
});

/** 아이디 찾기 */
router.post("/findId", async (req, res) => {
  const { birthday, name } = req.body;
  try {
    const connection = await connectToOracle();
    const result = await connection.execute(
      `SELECT id FROM TB_USER WHERE NAME = :name AND BIRTHDATE = TO_DATE(:birthday, 'YYYY/MM/DD HH24:MI:SS')`,
      { name: name, birthday: birthday }
    );

    connection.close();

    if (result.rows.length > 0) {
      res.json({ success: true, id: result.rows[0][0] });
    } else {
      res.json({ success: false, message: "일치하는 사용자가 없습니다" });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: "아이디 찾기 실패" });
  }
});

/** 비밀번호 찾기 - 임시 비밀번호 발송 */
router.post("/findPw", async (req, res) => {
  const generateRandomCode = () => {
    return Math.random().toString(36).slice(-8);
  };

  const { email } = req.body;
  const pw = generateRandomCode();

  const mailOptions = {
    to: email,
    subject: "PULSEPULSE 임시 비밀번호",
    text: `임시 비밀번호는 ${pw} 입니다.`,
  };

  let connection;

  try {
    connection = await connectToOracle();

    const result = await connection.execute(
      `SELECT id FROM tb_user WHERE ID = :id`,
      { id: email }
    );

    if (result.rows.length > 0) {
      try {
        const emailResponse = await sendmail.sendmail(
          mailOptions.to,
          mailOptions.subject,
          mailOptions.text
        );

        const hashedPw = bcrypt.hashSync(pw, 10);

        const result2 = await connection.execute(
          `UPDATE TB_USER SET pw = :pw WHERE ID = :email`,
          { pw: hashedPw, email: email },
          { autoCommit: true }
        );

        if (result2.rowsAffected > 0) {
          return res.status(200).send("임시 비밀번호 발급 성공");
        } else {
          return res.status(500).send("임시 비밀번호 발급 실패");
        }
      } catch (emailError) {
        return res.status(500).send(emailError.toString());
      }
    } else {
      return res.status(404).send("사용자를 찾을 수 없습니다.");
    }
  } catch {}
});

/** 비밀번호 변경 */
router.post("/changePw", async (req, res) => {
  const { id, forwardpw, backwardpw } = req.body;
  console.log("changer");
  let connection;

  try {
    connection = await connectToOracle();

    const result = await connection.execute(
      `SELECT pw from TB_USER WHERE id = :id`,
      { id: id }
    );

    const matchPw = bcrypt.compareSync(forwardpw, result.rows[0][0]);

    if (matchPw) {
      result2 = await connection.execute(
        `UPDATE TB_USER SET PW = :backwardpw WHERE ID = :id`,
        { backwardpw: backwardpw, id: id },
        { autoCommit: true }
      );

      if (result2.rowsAffected > 0) {
        res.status(200).json({ success: true, message: "비밀번호 변경 성공" });
      }
    } else {
      res
        .status(500)
        .json({ success: false, message: "비밀번호가 일치하지 않습니다" });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error });
  }
});

/** 프로필 수정 */
router.post("/profile", AuthToken, async (req, res) => {
  const id = req.user.id;
  const { birthdate, gender, height, weight } = req.body;

  let connection;
  try {
    connection = await connectToOracle();

    const result = await connection.execute(
      `UPDATE TB_USER SET BIRTHDATE = :birthdate, GENDER = :gender, HEIGHT = :height, WEIGHT = :weight WHERE ID = :id`,
      {
        birthdate: birthdate,
        gender: gender,
        height: height,
        weight: weight,
        id: id,
      },
      { autoCommit: true }
    );

    if (result.rowsAffected > 0) {
      res.status(200).json({ success: true, message: "프로필 변경 성공" });
    } else {
      res.status(500).json({ success: false, message: "프로필 변경 실패" });
    }

    await connection.close();
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 정보 업데이트
router.post("/infoUpdate", AuthToken, async (req, res) => {
  const id = req.user.id;
  const { name, birthdate, gender, height, weight } = req.body;
  const connection = await connectToOracle();
  console.log(req.body);
  if (connection) {
    try {
      const result = await connection.execute(
        "UPDATE TB_USER SET NAME = :name, BIRTHDATE = :birthdate, GENDER = :gender, HEIGHT = :height, WEIGHT = :weight WHERE ID = :id",
        { name, birthdate, gender, height, weight, id },
        { autoCommit: true }
      );
      console.log(result.rowsAffected);
      if (result.rowsAffected > 0) {
        res.status(200).json({ message: "정보 업데이트 성공" });
      }
    } catch (error) {
      res.status(500).json({ message: "정보 업데이트 실패" });
    } finally {
      connection.close();
    }
  } else {
    res.status(500).json({ message: "db 연결 실패" });
  }
});

module.exports = router;
