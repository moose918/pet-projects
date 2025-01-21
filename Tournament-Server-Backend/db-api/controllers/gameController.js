const db = require('../util/db');
const responseHandler = require('../util/responseHandler');

exports.getAllGames = async (req, res) => {
  const RETRIEVE_ALL_GAMES = 'SELECT * FROM `GAME`';

  await db
    .execute(RETRIEVE_ALL_GAMES)
    .then(([rows, fields]) => {
      return responseHandler.returnSuccess(
        res,
        200,
        'Games retrieved successfully',
        rows
      );
    })
    .catch((err) => {
      return responseHandler.returnError(
        res,
        502,
        err,
        'Unable to retrieve all games from the database'
      );
    });
};

exports.addNewGame = async (req, res) => {
  const clientInput = req.body.data;
  const INSERT_GAME = `CALL insert_game("${clientInput.gameName}", "${
    clientInput.fileName
  }", ${clientInput.isSync ? 1 : 0})`;

  await db
    .execute(INSERT_GAME)
    .then(([rows, fields]) => {
      return responseHandler.returnSuccess(
        res,
        201,
        'Game added successfully',
        rows[0]
      );
    })
    .catch((err) => {
      responseHandler.returnError(
        res,
        502,
        err,
        'Unable to insert and/or retire the game'
      );
    });
};

exports.fetchGAme = async (req, res) => {
  res.end();
}; // TODO: implement

exports.updateGame = async (req, res) => {
  const clientInput = req.body.data;
  res.end(); // TODO: implement
};
