const db = require('mysql2');

const dbPool = db
  .createPool({
    host: 'tourney-server-dev.crw7j7mduhsz.af-south-1.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    database: 'tourney_server',
    password: '44gRmEvP9xLhR6d',
  })
  .promise();

// const dbPool = db
// .createPool({
//   host: 'tourey-server-dev.c2ncyvtifq7i.us-east-1.rds.amazonaws.com',
//   port: 3306,
//   user: 'admin',
//   database: 'tourney_server',
//   password: '44gRmEvP9xLhR6d',
// })
// .promise();
// const dbPool = db.createPool({
//   host: 'localhost',
//   port: 3307,
//   user: 'admin',
//   database: 'tourney_server',
//   password: '44gRmEvP9xLhR6d',
// });

// const dbPool = db.createPool({
//   host: 'localhost',
//   port: 3306,
//   user: 'root',
//   database: 'tourney_server',
//   password: '',
// });

// exports.executeStmt = async (stmt, multipleRows) => {
//   let success, returnValue;

//   await dbPool.execute(stmt)
//   .then( ([rows, fields]) =>{
//     success = true;

//     if (multipleRows)
//       returnValue = rows[0];
//   })
// }
module.exports = dbPool;
