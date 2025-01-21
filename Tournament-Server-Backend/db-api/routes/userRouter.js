const express = require('express');

const userController = require('../controllers/userController');

const router = express.Router();

router
  .route('/')
  .get(userController.getAllUsers)
  .put(userController.checkReqBody, userController.insertUser)
  .post(userController.checkLogin, userController.getUser);

router.route('/signupCheck').post(userController.checkUsername);
router.route('/update').patch(userController.updateUser);

module.exports = router;
