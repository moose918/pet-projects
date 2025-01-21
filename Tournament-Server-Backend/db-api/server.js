const dotenv = require('dotenv'); // Allows the use of config.env variables
const app = require('./app');

dotenv.config({ path: './config.env' });

const port = process.env.PORT || 8080 || 8090 || 8000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}...`);
});
