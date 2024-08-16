process.env.ORA_SDTZ = "Asia/Seoul";
require("dotenv").config();
const express = require("express"); //
const cors = require("cors");
const bodyParser = require("body-parser");

const passport = require("passport");
const session = require("express-session");
const passportConfig = require("./passport/passportConfig");
const app = express();
const port = 3000;

passportConfig();

app.use(cors());
app.use(bodyParser.json({ limit: "10mb" }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json()); //
app.use(
  session({
    secret: process.env.SESSION_SECRET || "default_session_secret", // 세션 비밀 키
    resave: false,
    saveUninitialized: true,
  })
);
app.use(passport.initialize());
app.use(passport.session());

const router = require("./routes/router");

// app.use(cors()); // cors
// app.use(bodyParser.json({ limit: '10mb' })); // json 파싱
// app.use(bodyParser.urlencoded({ extended: true })); // url-encoded 파싱
// app.use(express.json()); //json 요청 바디 파싱

// 알림
app.use("/", router); // / -> /api로 바꿈

app.listen(port, () => {
  console.log(`Server is running at http://192.168.219.228:${port}`);
});
