const express = require('express');

const gameController = require('../controllers/gameController');

const router = express.Router();

router
  .route('/')
  .get(gameController.getAllGames)
  .put(gameController.addNewGame)
  .patch(gameController.updateGame);

module.exports = router;
