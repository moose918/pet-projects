const express = require('express');

const matchController = require('../controllers/matchController');

const router = express.Router();

// TODO ? When obtaining filtered matches, make a separate get to retrieve the list of participating agents in the match

router
  .route('/')
  .post(matchController.processFilter, matchController.getFilteredMatches) // First process the filter query string
  .put(matchController.insertMatch, matchController.insertAgentResults);
router
  .route('/live')
  .put(matchController.startLiveMatch, matchController.insertAgentResults)
  .post(matchController.endLiveMatch, matchController.updateAgentResults);
router.route('/live/:tournamentID?').get(matchController.getLiveMatches);

module.exports = router;
