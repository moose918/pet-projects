const express = require('express');
const profileController = require('../controllers/profileController')

const router = express.Router();

router.route('/').post(profileController.getProfile)

module.exports = router;