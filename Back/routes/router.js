const express = require("express");
const router = express.Router();
const userRoutes = require("./user");
const analysisRoutes = require("./analysis");
const connectToOracle = require("../config/db.js");

const resultRoutes = require("./result");
const memoRoutes = require("./memo");
const AuthRoutes = require("./auth");
const hospitalRoutes = require("./hospitals");
// 알림
// const pushNotificationController = require("../controllers/push-notifications.controller.js");

router.use("/user", userRoutes);
router.use("/", analysisRoutes);
router.use("/", memoRoutes);
router.use("/", resultRoutes);
router.use("/auth", AuthRoutes);
router.use("/", hospitalRoutes);

// 알림
// router.post(
//   "/send-notification",
//   pushNotificationController.sendPushNotification
// );

// router.get("/", async (req, res) => {
//   res.sendFile(__dirname + "/test.html");
// });

// 알림 dush PAGE
router.get("/push_send", function (req, res, next) {
  let target_token =
    "fQAKRZ1lT023AhuHA7hDuX:APA91bGr79JINlpSJxrFIBTZJwcJjZq66hgxVgImf3bdfYqCWPtWMoMvauKLPfXLIXQ1fKX4O8X2ke4FBF2ZP7WaFdV_q3rElkKh_GAWPe_3BHL4Fl9au8aT01Fhk2q35i_gpl9cXPIp";
  //target_token은 푸시 메시지를 받을 디바이스의 토큰값입니다

  let message = {
    data: {
      title: "테스트 데이터 발송",
      body: "데이터가 잘 가나요?",
      style: "굳굳",
    },
    token: target_token,
  };

  admin
    .messaging()
    .send(message)
    .then(function (response) {
      console.log("Successfully sent message: : ", response);
    })
    .catch(function (err) {
      console.log("Error Sending message!!! : ", err);
    });
});

module.exports = router;
