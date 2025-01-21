const db = require('../util/db');
const resultHandler = require('../util/responseHandler');

exports.checkLogin = async (req, res, next) => {
  const clientInput = req.body.data;

  if (!clientInput.username_email || clientInput.username_email === '') {
    return resultHandler.returnError(
      res,
      400,
      new Error('username_email is the incorrect format'),
      'Missing username/email required'
    );
  }

  next();
};

// Debugging for frontend
exports.checkReqBody = async (req, res, next) => {
  const clientInput = req.body.data;

  if (!clientInput.fName || clientInput.fName === '') {
    return resultHandler.returnError(
      res,
      400,
      new Error('fName is incorrect'),
      'Missing fName required'
    );
  }

  next();
};

exports.checkUsername = async (req, res) => {
  const clientInput = req.body.data;
  const CHECK_IF_USERNAME_EXISTS = `CALL check_existing_user("${clientInput.username}");`;

  await db
    .execute(CHECK_IF_USERNAME_EXISTS)
    .then(([rows, fields]) => {
      if (rows[0][0].USER_COUNT === 0)
        return resultHandler.returnSuccess(
          res,
          202,
          'You may use this username',
          null
        );
      return resultHandler.returnError(
        res,
        400,
        null,
        'There is an existing user with this username'
      );
    })
    .catch((err) =>
      resultHandler.returnError(
        res,
        err,
        "Error when checking for the username's existence"
      )
    );
};

exports.getAllUsers = async (req, res) => {
  const RETRIEVE_USERS = 'SELECT * FROM `USER`;';

  await db
    .execute(RETRIEVE_USERS)
    .then(([rows, fields]) =>
      resultHandler.returnSuccess(
        res,
        200,
        'The users have been successfully retrieved',
        rows
      )
    )
    .catch((err) =>
      resultHandler.returnError(res, 502, err, 'Unable to retrieve users')
    );
};

exports.insertUser = async (req, res) => {
  const clientInput = req.body.data;
  const INSERT_USER = `CALL insert_user ("${clientInput.fName}", "${
    clientInput.lName
  }", 
     "${clientInput.username}", "${clientInput.userEmail}", "${
    clientInput.userPass
  }", ${clientInput.isAdmin === 'true' || clientInput.isAdmin ? 1 : 0}, ${
    clientInput.wantsNotifications === 'true' || clientInput.wantsNotifications
      ? 1
      : 0
  }, "${
    clientInput.userDP == null || clientInput.userDP === ''
      ? 'default.png'
      : clientInput.userDP
  }", "${clientInput.userDescription}")`;

  await db
    .execute(INSERT_USER)
    .then(([rows, fields]) =>
      // console.log(rows[0]);

      resultHandler.returnSuccess(
        res,
        201,
        'The user has been stored successfully',
        rows[0][0]
      )
    )
    .catch((err) =>
      resultHandler.returnError(
        res,
        502,
        err,
        'Unable to add new user to the database'
      )
    );
};

exports.getUser = async (req, res) => {
  const clientInput = req.body.data;
  const RETRIEVE_USER = `CALL get_user("${clientInput.username_email}", "${clientInput.username_email}", "${clientInput.passwd}");`;

  await db
    .execute(RETRIEVE_USER)
    .then(([rows, fields]) => {
      if (rows[0].length > 0)
        return resultHandler.returnSuccess(
          res,
          200,
          'User retrieved',
          rows[0][0]
        );
      return resultHandler.returnError(res, 404, 'User not found');
    })
    .catch((err) =>
      resultHandler.returnError(
        res,
        502,
        err,
        'Unable to retrieve user from the database'
      )
    );
};

exports.updateUser = async (req, res) => {
  const clientInput = req.body.data;
  // TODO: This
};
