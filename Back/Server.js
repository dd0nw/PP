process.env.ORA_SDTZ = "Asia/Seoul";
require("dotenv").config();
const express = require("express");
const oracledb = require("oracledb");
const cors = require("cors");
const app = express();
const port = 3000;

oracledb.autoCommit = true;
oracledb.initOracleClient({
  libDir: "C:/Users/smhrd/Desktop/instantclient_11_2",
});

const router = require("./routes/router");
app.use(cors()); // cors
app.use(express.json()); //json 요청 바디 파싱
app.use("/", router);

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
