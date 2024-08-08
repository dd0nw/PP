const express = require("express");
const router = express.Router();
const userRoutes = require("./user");
const analysisRoutes = require("./analysis");
const resultRoutes = require("./result");
const memoRoutes = require("./memo");

router.use("/", userRoutes);
router.use("/", analysisRoutes);
router.use("/", memoRoutes);
router.use("/", resultRoutes);

router.get("/", async (req, res) => {
  res.sendFile(__dirname + '/test.html');
});

module.exports = router;
