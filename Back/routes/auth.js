const express = require('express');
const passport = require('passport');
const router = express.Router();

// 로그 미들웨어
const logMiddleware = (req, res, next) => {
  console.log('Route hit:', req.originalUrl);
  next();
};

// 카카오 로그인 라우터
router.get('/kakao', logMiddleware, passport.authenticate('kakao'));

// 카카오 로그인 콜백 라우터
router.get('/kakao/callback', logMiddleware, passport.authenticate('kakao', {
  failureRedirect: '/',
}), (req, res) => {
  console.log('Kakao login callback route hit');
  if (!req.user) {
    console.error('Login failed: no user object');
    return res.redirect('/');
  }
  res.redirect(`/?token=${req.user.token}`);
});

// 구글 로그인 라우터
router.get('/google', logMiddleware, passport.authenticate('google', { scope: ['profile', 'email'] }));

// 구글 로그인 콜백 라우터
router.get('/google/callback', logMiddleware, passport.authenticate('google', {
  failureRedirect: '/',
}), (req, res) => {
  if (!req.user) {
    console.error('Login failed: no user object');
    return res.redirect('/');
  }
  res.redirect(`/?token=${req.user.token}`);
});

module.exports = router;
