const express = require("express");
const router = express.Router();
const userRoutes = require("./user");
const analysisRoutes = require("./analysis");
const connectToOracle = require("../config/db.js");

const resultRoutes = require("./result");
const memoRoutes = require("./memo");
const AuthRoutes = require("./auth");
// 알림
const pushNotificationController = require("../controllers/push-notifications.controller.js");

router.use("/user", userRoutes);
router.use("/", analysisRoutes);
router.use("/", memoRoutes);
router.use("/", resultRoutes);
router.use("/auth", AuthRoutes);

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
    "fs8n1QmvQNCLReyHBVBDCq:APA91bGbU0Lqh58Lysb8Hv3Md1Fg7LRtVXl23h6R3C39lyMADtKZDqVk6beS9QtpO9x_AKbESpzhWk2BGeaJYoGjibAo5mmeITwv_MBZDjDmo0TmVLee1lhu3pJbnqEBeaufVH3cSL_5";
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
