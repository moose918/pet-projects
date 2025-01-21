const express = require('express'); // Framework for node
const morgan = require('morgan'); // HTTP request logger
const cors = require('cors'); // CORS middleware

const app = express();

////////////////////////////////
/// Middleware for nonexistent endpoints
////////////////////////////////
const notfoundHandler = async (req, res, next) => {
  const errorMsg = `<h1>Could not find the page you were looking for</h1>
                  <p>Please check the <a href="/">docs</a> for the available links and try again.</p>`;
  res.status(404).send(errorMsg);

  next();
};

////////////////////////////////
/// Routers
////////////////////////////////
const userRouter = require('./routes/userRouter');
const profileRouter = require('./routes/profileRouter');
const agentRouter = require('./routes/agentRouter');
const gameRouter = require('./routes/gameRouter');
const tournamentRouter = require('./routes/tournamentRouter');
const matchRouter = require('./routes/matchRouter');

////////////////////////////////
/// Middleware
////////////////////////////////
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev')); // Debug logging for HTTP requests
}

app.use(cors()); // Enables CORS

app.use(express.json()); // Parse the body into json

// Log the time the file was requested
app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  next();
});

////////////////////////////////
/// Routes
////////////////////////////////
// TODO Divide users and admins
// TODO Don't show inactive tournaments to users, how do we know it's inactive????? frontend???
// TODO User's agent management console
// TODO Admin's tournament management console

app.use('/api/v2/user', userRouter);
app.use('/api/v2/profile', profileRouter);
app.use('/api/v2/agent', agentRouter);
app.use('/api/v2/game', gameRouter);
app.use('/api/v2/tournament', tournamentRouter);
app.use('/api/v2/match', matchRouter);

// Provide the /public directory for file transfer on either root server links
app.use('/', express.static(`${__dirname}/public`));
app.use('/api/v2', express.static(`${__dirname}/public`));

app.use(notfoundHandler); // When a call to a nonexistent endpoint is made, the user needs to be informed

module.exports = app;
