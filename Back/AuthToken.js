const jwt = require("jsonwebtoken");

const jwtSecret = process.env.JWT_SECRET;

function AuthToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1]; //;Bearer 토큰 형식
  if (token == null) return res.sendStatus(401); // 토큰이 없는 경우

  jwt.verify(token, jwtSecret, (err, user) => {
    if (err) return res.sendStatus(403); // 토큰이 유효하지 않은 경우
    req.user = user; // 토큰에서 디코딩된 사용자 정보를 req.user에 저장
    next();
  });
}

module.exports = AuthToken;
