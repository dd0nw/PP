const express = require("express");
const router = express.Router();
const userRoutes = require("./user");
const analysisRoutes = require("./analysis");
const connectToOracle = require("../config/db.js");

const resultRoutes = require("./result");
const memoRoutes = require("./memo");

router.use("/user", userRoutes);
router.use("/", analysisRoutes);
<<<<<<< HEAD

=======
>>>>>>> 38489305908085832ee8e9142a9d2ce1a5ff6eb6
router.use("/", memoRoutes);
router.use("/", resultRoutes);

router.get("/", async (req, res) => {
  res.sendFile(__dirname + "/test.html");
});

module.exports = router;
