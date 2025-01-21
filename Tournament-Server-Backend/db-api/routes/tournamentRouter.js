const express = require('express');

const tournamentController = require('../controllers/tournamentController');

const router = express.Router();

router
  .route('/')
  .post(
    tournamentController.filterTournaments,
    tournamentController.getTournaments
  )
  .put(tournamentController.insertTournament)
  .delete(tournamentController.deleteTournament);
router.route('/open').post(tournamentController.openTournament);
router.route('/close').post(tournamentController.closeTournament);

module.exports = router;
