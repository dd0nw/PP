try {
    process.env.ORA_SDTZ = 'Asia/Seoul';
    const oracledb = require('oracledb');
    oracledb.autoCommit = true;
  
    console.log('Initializing Oracle client...');
    oracledb.initOracleClient({ libDir: 'C:/Users/smhrd/Desktop/instantclient' });
  
    const dbConfig = {
      user: 'cgi_24S_IoT3_1', 
      password: 'smhrd1', 
      connectString: 'project-db-cgi.smhrd.com:1524/xe'
    };
  
    async function connectToOracle() {
      try {
        console.log('Attempting to connect to the Oracle database...');
        const connection = await oracledb.getConnection(dbConfig);
        console.log('Successfully connected to Oracle database');
  
        await connection.execute(`ALTER SESSION SET TIME_ZONE='UTC'`);
  
        const result = await connection.execute(`SELECT SYSDATE FROM DUAL`);
        console.log('Current date and time: ', result.rows[0]);
  
        return connection;
  
      } catch (err) {
        console.error('Connection failed: ', err);
      }
    }
  
    // 테스트 실행
    console.log('Starting connection test...');
    connectToOracle().then(connection => {
      if (connection) {
        console.log('Connection test completed successfully.');
      }
    }).catch(err => {
      console.error('Error during connection test: ', err);
    });
  
    module.exports = {
      connectToOracle: connectToOracle
    };
  
  } catch (err) {
    console.error('Initialization failed: ', err);
  }
  