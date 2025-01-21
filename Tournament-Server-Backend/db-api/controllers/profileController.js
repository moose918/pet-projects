const db = require('../util/db');
const responseHandler = require('../util/responseHandler');

exports.getProfile = async (req, res) => {
  const clientInput = req.body.data;
  const GET_USER_PROFILE = `CALL get_user_profile("${clientInput.userID}")`;

  await db
    .execute(GET_USER_PROFILE)
    .then(([rows, fields]) => {
      responseHandler.returnSuccess(
        res,
        200,
        'User profile retrieved successfully',
        rows[0][0]
      );
    })
    .catch((err) => {
      responseHandler.returnError(
        res,
        502,
        err,
        'Unable to retrieve user profile'
      );
    });
};
