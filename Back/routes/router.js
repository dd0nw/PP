const express = require("express");
const router = express.Router();
const userRoutes = require("./user");
const analysisRoutes = require("./analysis");

router.use("/user", userRoutes);
router.use("/analysis", analysisRoutes);

router.get("/", async (req, res) => {
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(`SELECT SYSDATE FROM DUAL`);
      res.send(`Current date and time: ${result.rows[0]}`);
      await connection.close();
    } catch (err) {
      res.status(500).send("Error executing query");
      console.error("Error executing query: ", err);
    }
  } else {
    res.status(500).send("Error connecting to database");
  }
});

module.exports = router;
