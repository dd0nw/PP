const jwt = require("jsonwebtoken");

const jwtSecret = process.env.JWT_SECRET;

function AuthToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1]; // Assuming 'Bearer <token>' format

  if (!token) {
    return res.status(401).json({ message: "No token provided" });
  }

  jwt.verify(token, jwtSecret, (err, decoded) => {
    if (err) {
      console.error("Failed to authenticate token:", err.message);
      if (err.name === "TokenExpiredError") {
        return res.status(403).json({ message: "Token expired" });
      } else {
        return res
          .status(403)
          .json({ message: "Failed to authenticate token" });
      }
    }
    req.user = decoded; // Decoded user information from token
    next();
  });
}

module.exports = AuthToken;
