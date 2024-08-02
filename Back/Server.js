process.env.ORA_SDTZ = "Asia/Seoul";
require("dotenv").config();
const express = require("express");
const oracledb = require("oracledb");
const cors = require("cors");
const app = express();
const crypto = require("crypto");
const port = 3000;

const router = require("./routes/router");
app.use(cors()); // cors
app.use(express.json()); //json 요청 바디 파싱
app.use("/", router);

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
