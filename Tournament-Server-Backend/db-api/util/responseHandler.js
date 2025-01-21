exports.returnSuccess = (res, statusCode, message, rows) => {

  return res
    .status(statusCode)
    .json({ status: 'success', message: message, resultData: rows });
};
exports.returnError = (res, statusCode, err, msg) => {

  return res.status(statusCode).json({
    status: 'failed',
    message: msg,
    logError: err,
  });
};
