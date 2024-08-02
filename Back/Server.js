process.env.ORA_SDTZ = "Asia/Seoul";
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

const router = require("./routes/router");
app.use(cors()); // cors
app.use(bodyParser.json({ limit: '10mb' })); // json 파싱
app.use(bodyParser.urlencoded({ extended: true })); // url-encoded 파싱
app.use(express.json()); //json 요청 바디 파싱
app.use("/", router);

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
