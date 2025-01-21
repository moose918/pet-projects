const db = require('../util/db');
const resultHandler = require('../util/responseHandler');

exports.filterTournaments = async (req, res, next) => {
  const clientInput = req.body.data;
  let whereCondition;

  if (clientInput.isOpen !== undefined) {
    whereCondition = `TOURNAMENT_IS_OPEN = ${
      clientInput.isOpen === true ? 1 : 0
    }`;
  } else whereCondition = 'true';

  clientInput.whereCondition = whereCondition;

  next();
};
exports.getTournaments = async (req, res) => {
  const clientInput = req.body.data;
  const GET_ALL_TOURNAMENTS = `CALL get_tournaments('${clientInput.whereCondition}')`;

  console.log(GET_ALL_TOURNAMENTS);
  await db
    .execute(GET_ALL_TOURNAMENTS)
    .then(([rows, fields]) => {
      return resultHandler.returnSuccess(
        res,
        201,
        'Retrieved torunaments successfully',
        rows[0]
      );
    })
    .catch((err) => {
      return resultHandler.returnError(
        res,
        502,
        err,
        'Unable to add the tournament'
      );
    });
};
exports.insertTournament = async (req, res) => {
  const clientInput = req.body.data;
  const INSERT_TOURNAMENT = `CALL insert_tournament("${clientInput.tournamentName}", "${clientInput.gameID}", "${clientInput.tournamentDP}")`;

  await db
    .execute(INSERT_TOURNAMENT)
    .then(([rows, fields]) => {
      return resultHandler.returnSuccess(
        res,
        201,
        'Tournament added successfully',
        rows[0][0]
      );
    })
    .catch((err) => {
      return resultHandler.returnError(
        res,
        502,
        err,
        'Unable to add the tournament'
      );
    });
};

exports.openTournament = async (req, res) => {
  const tournamentID = req.body.data.tournamentID;
  const OPEN_TOURNAMENT = `CALL open_tournament("${tournamentID}")`;

  await db
    .execute(OPEN_TOURNAMENT)
    .then(([rows, fields]) => {
      return resultHandler.returnSuccess(
        res,
        200,
        'Tournament has been opened successfully',
        null
      );
    })
    .catch((err) => {
      return resultHandler.returnError(
        res,
        502,
        err,
        'Unable to open the tournament'
      );
    });
};

exports.closeTournament = async (req, res) => {
  const tournamentID = req.body.data.tournamentID;
  const CLOSE_TOURNAMENT = `CALL close_tournament("${tournamentID}")`;

  await db
    .execute(CLOSE_TOURNAMENT)
    .then(([rows, fields]) => {
      return resultHandler.returnSuccess(
        res,
        200,
        'Tournament has been closed successfully',
        null
      );
    })
    .catch((err) => {
      return resultHandler.returnError(
        res,
        502,
        err,
        'Unable to close the tournament'
      );
    });
};

exports.deleteTournament = async (req, res) => {
  // TODO: this
};
