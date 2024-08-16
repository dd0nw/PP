const express = require("express");
const router = express.Router();
const connectToOracle = require("../config/db");
const AuthToken = require("../AuthToken");
const admin = require("../controllers/push-notifications.controller"); // Firebase Admin 모듈
const axios = require("axios");
require("dotenv").config();
const FCM = require("fcm-node");

const TARGET_TOKEN = process.env.TARGET_TOKEN;
const fcm = new FCM(process.env.FCM_SERVER_KEY); // FCM 서버 키를 환경 변수에서 가져옵니다.

// CLOB을 문자열로 변환하는 함수
async function convertClobAsString(lob) {
  return new Promise((resolve, reject) => {
    if (lob === null) {
      return resolve(null);
    }

    let clobString = "";

    lob.setEncoding("utf8");

    lob.on("data", (chunk) => {
      clobString += chunk;
    });

    lob.on("end", () => {
      resolve(clobString);
    });

    lob.on("error", (err) => {
      reject(err);
    });
  });
}

// BLOB을 Base64로 변환하는 함수
async function getBlobAsBase64(lob) {
  return new Promise((resolve, reject) => {
    if (!lob) {
      return resolve(null);
    }

    const chunks = [];

    lob.on("data", (chunk) => {
      chunks.push(chunk);
    });

    lob.on("end", () => {
      const buffer = Buffer.concat(chunks);
      const base64String = buffer.toString("base64");
      resolve(base64String);
    });

    lob.on("error", (err) => {
      reject(err);
    });
  });
}

// Base64 문자열을 소수점 3자리까지의 숫자 배열로 변환하는 함수
function decodeBase64ToNumberArray(base64String) {
  try {
    const buffer = Buffer.from(base64String, "base64");
    const floatArray = new Float64Array(
      buffer.buffer,
      buffer.byteOffset,
      buffer.length / Float64Array.BYTES_PER_ELEMENT
    );
    return Array.from(floatArray).map((num) => parseFloat(num.toFixed(3)));
  } catch (error) {
    console.error("Error decoding Base64 string:", error);
    return [];
  }
}

function getMaxValueFromResult(resultString) {
  const regex = /([A-Z/]): (\d+\.\d+)/g;
  let match;
  const values = {};

  while ((match = regex.exec(resultString)) !== null) {
    values[match[1]] = parseFloat(match[2]);
  }

  if (Object.keys(values).length === 0) {
    return "No valid data found";
  }

  const maxKey = Object.keys(values).reduce((a, b) =>
    values[a] > values[b] ? a : b
  );
  const maxValue = values[maxKey].toFixed(4);

  const messages = {
    N: `정상 심박수`,
    R: `심방세동`,
    L: `심실빈맥:`,
    V: `심실 조기 수축`,
    "/": `인공 심박 조율기 박동`,
  };

  return messages[maxKey] || `알 수 없는 항목: ${maxValue}`;
}

/** 부정맥 발생 의심 목록 불러오기 */
router.post("/analysis", AuthToken, async (req, res) => {
  const id = req.user.id;
  const date = req.body.createdAt;
  const connection = await connectToOracle();
  console.log(req.body);
  if (connection) {
    try {
      const result = await connection.execute(
        `SELECT 
          analysis_idx, 
          id, 
          bp_avg,
          TO_CHAR(created_at, 'HH24:MI:SS') as created_at, 
          TO_CHAR(created_at, 'YYYY/MM/DD HH24:MI:SS') AS fulldate, 
          RR_MIN, 
          RR_MAX, 
          RR_AVG, 
          RR_STD, 
          ANALISYS_RESULT,
          ANALISYS_ETC,
          ECG 
        FROM tb_analysis 
        WHERE TO_CHAR(CREATED_AT, 'YYYY/MM/DD')=(:create_at) AND ID=:id 
        ORDER BY CREATED_AT DESC`,
        { create_at: date, id: id }
      );

      const rows = result.rows;
      const convertedRows = [];

      for (let row of rows) {
        const ecgBase64 = await getBlobAsBase64(row[11]);
        const ecgNumberArray = decodeBase64ToNumberArray(ecgBase64);

        const convertedRow = {
          ANALYSIS_IDX: row[0],
          ID: row[1],
          BP_AVG: row[2],
          CREATED_AT: row[3],
          FULLDATE: row[4],
          RR_MIN: row[5],
          RR_MAX: row[6],
          RR_AVG: row[7],
          RR_STD: row[8],
          ANALISYS_RESULT: getMaxValueFromResult(
            await convertClobAsString(row[9])
          ),
          ANALISYS_ETC: await convertClobAsString(row[10]),
          ECG: ecgNumberArray,
        };
        console.log(convertedRow);
        convertedRows.push(convertedRow);
      }
      res.status(200).json(convertedRows);
      console.log(convertedRows);
      await connection.close();
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

/////////////////////알림

// 푸시 알림 전송 함수 (fcm-node 사용)
async function sendNotificationToFlutter() {
  const message = {
    to: TARGET_TOKEN, // 타겟 디바이스의 FCM 토큰
    notification: {
      title: "테스트 데이터 발송",
      body: "데이터가 잘 가나요?",
    },
    data: {
      style: "굳굳",
    },
  };

  fcm.send(message, function (err, response) {
    if (err) {
      console.error("Error sending notification:", err);
    } else {
      console.log("Successfully sent with response: ", response);
    }
  });
}

// 데이터베이스 변경 확인 함수
async function checkForUpdates() {
  let connection;
  try {
    connection = await connectToOracle();

    // 1초 전의 시간을 계산하여 현재 시간과 비교합니다.
    const result = await connection.execute(
      `SELECT * FROM tb_analysis WHERE modified_at > SYSDATE - INTERVAL '6' SECOND`
    );
    if (result.rows.length > 0) {
      console.log("Data changed - sending notification");
      await sendNotificationToFlutter();
    } else {
      //console.log("No data changes detected");
    }
  } catch (err) {
    console.error("Error checking for updates:", err);
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error("Error closing connection:", err);
      }
    }
  }
}

// 주기적으로 데이터베이스를 확인합니다.
setInterval(checkForUpdates, 6000);

// 푸시 알림 전송 엔드포인트
router.get("/push_send", function (req, res, next) {
  sendNotificationToFlutter()
    .then(() => res.status(200).send("Notification sent successfully"))
    .catch((err) => {
      console.error("Error sending notification: ", err);
      res.status(500).send("Error sending notification");
    });
});

module.exports = router;
