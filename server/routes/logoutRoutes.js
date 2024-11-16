const express = require("express");
const logoutRouter = express.Router();

logoutRouter.post("/api/auth/logout", (req, res) => {
  try {
    res.status(200).json({ message: "Logout successful" });
  } catch (error) {
    res.status(500).json({ error: "Failed to log out" });
  }
});

module.exports = logoutRouter;
