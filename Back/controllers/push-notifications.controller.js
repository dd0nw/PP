// // 알림
// var admin = require("firebase-admin");
// var fcm = require("fcm-notification");

// // Firebase 서비스계정키
// var serviceAccount = require("../config/push-notification-key.json");
// const certPath = admin.credential.cert(serviceAccount);
// var FCM = new fcm(certPath);

// // 푸시 알림 보냄
// exports.sendPushNotification = (req, res, next) => {
//   try {
//     // 푸시 알림 메시지
//     let message = {
//       notification: {
//         title: "Test Notification",
//         body: "Notification Message",
//       },

//       data: {
//         orderId: 123456,
//         orderDate: "2022-10-28",
//       },
//       token: req.body.fcm_token, // fcm_token 메시지 받을 기기
//     };

//     // Fcm 사용해 메시지 전송 함수
//     FCM.send(message, function (err, resp) {
//       if (err) {
//         return res.status(500).send({
//           message: err,
//         });
//       } else {
//         return res.status(200).send({
//           // 전송성공
//           message: "Notification Sent",
//         });
//       }
//     });
//   } catch (err) {
//     throw err;
//   }
// };

const admin = require("firebase-admin");

let serAccount = require("../config/push-notification-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serAccount),
});

module.exports = admin;

// // push PAGE
// router.get("/push_send", function (req, res, next) {
//   let target_token =
//     "fs8n1QmvQNCLReyHBVBDCq:APA91bGbU0Lqh58Lysb8Hv3Md1Fg7LRtVXl23h6R3C39lyMADtKZDqVk6beS9QtpO9x_AKbESpzhWk2BGeaJYoGjibAo5mmeITwv_MBZDjDmo0TmVLee1lhu3pJbnqEBeaufVH3cSL_5";
//   //target_token은 푸시 메시지를 받을 디바이스의 토큰값입니다

//   let message = {
//     data: {
//       title: "테스트 데이터 발송",
//       body: "데이터가 잘 가나요?",
//       style: "굳굳",
//     },
//     token: target_token,
//   };

//   admin
//     .messaging()
//     .send(message)
//     .then(function (response) {
//       console.log("Successfully sent message: : ", response);
//     })
//     .catch(function (err) {
//       console.log("Error Sending message!!! : ", err);
//     });
// });
