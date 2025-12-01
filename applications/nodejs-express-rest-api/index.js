const express = require("express");

const app = express();

const FAILURE_EXIT_CODE = 1;
const DEFAULT_PORT = 8080;

app.use(express.json());

// root path end point
app.get("/", (req, res) => {
  res.json({ message: "Hello World from Node + Express" });
});

// health check end point
app.get("/health", (req, res) => {
  res.json({ status: "OK" });
});

// crashes the node application after a quick timer
app.post("/crash", (req, res) => {
  res.json({ status: "crashing" });

  setTimeout(() => {
    process.exit(FAILURE_EXIT_CODE);
  }, 100);
});

const port = process.env.PORT || DEFAULT_PORT;

app.listen(port, () => {
  console.log(`Node app listening on port ${port}`);
});
