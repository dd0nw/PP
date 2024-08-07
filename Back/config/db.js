const oracledb = require("oracledb");

process.env.ORA_SDTZ = "Asia/Seoul";
oracledb.autoCommit = true;

oracledb.initOracleClient({ libDir: "C:/Users/smhrd/Desktop/instantclient_11_2" });

  const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
  };

  
  async function connectToOracle() {
    try {
      const connection = await oracledb.getConnection(dbConfig);
      await connection.execute(`ALTER SESSION SET TIME_ZONE='UTC'`);
      return connection;
    } catch (err) {
      console.error("Connection failed: ", err);
    }
  } 

  module.exports = connectToOracle;