// MySQL connection pool. Change the settings with environment variables (see README).
const mysql = require('mysql2/promise');

module.exports = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'library',
  waitForConnections: true,
  connectionLimit: 5,
  decimalNumbers: true,     // DECIMAL columns come back as numbers, not strings
  dateStrings: true         // DATE columns come back as 'YYYY-MM-DD' text (no time-zone shift)
});
