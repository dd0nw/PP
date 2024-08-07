const express = require('express');
const passport = require('passport');
const router = express.Router();

// 카카오 로그인 라우터
router.get('/kakao', passport.authenticate('kakao'));

// 카카오 로그인 콜백 라우터
router.get('/kakao/callback', passport.authenticate('kakao', {
  failureRedirect: '/',
}), (req, res) => {
  // 로그인 성공 시 토큰 전달
  res.redirect(`/?token=${req.user.token}`);
});

// 구글 로그인 라우터
router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// 구글 로그인 콜백 라우터
router.get('/google/callback', passport.authenticate('google', {
  failureRedirect: '/',
}), (req, res) => {
  // 로그인 성공 시 토큰 전달
  res.redirect(`/?token=${req.user.token}`);
});

module.exports = router;
