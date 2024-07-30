process.env.ORA_SDTZ = 'Asia/Seoul';
const express = require('express');
const oracledb = require('oracledb');
const app = express();
const port = 3000;

oracledb.autoCommit = true;
oracledb.initOracleClient({ libDir: 'C:/Users/smhrd/Desktop/instantclient' });

const dbConfig = {
  user: 'cgi_24S_IoT3_1',
  password: 'smhrd1',
  connectString: 'project-db-cgi.smhrd.com:1524/xe'
};

async function connectToOracle() {
  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Successfully connected to Oracle database');
    await connection.execute(`ALTER SESSION SET TIME_ZONE='UTC'`);
    return connection;
  } catch (err) {
    console.error('Connection failed: ', err);
  }
}

app.get('/', async (req, res) => {
  const connection = await connectToOracle();
  if (connection) {
    try {
      const result = await connection.execute(`SELECT SYSDATE FROM DUAL`);
      res.send(`Current date and time: ${result.rows[0]}`);
      await connection.close();
    } catch (err) {
      res.status(500).send('Error executing query');
      console.error('Error executing query: ', err);
    }
  } else {
    res.status(500).send('Error connecting to database');
  }
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
