const express = require('express');
const passport = require('passport');
const router = express.Router();
const axios = require('axios');

// 로그 미들웨어
const logMiddleware = (req, res, next) => {
  console.log('Route hit:', req.originalUrl);
  next();
};

// 카카오 로그인 라우터
router.get('/kakao', logMiddleware, passport.authenticate('kakao'));

// 카카오 로그인 콜백 라우터
router.get('/kakao/callback', async (req, res, next) => {
  const { code } = req.query;
  console.log("code",req.query);

  try {
    // 카카오에 인증 코드를 사용하여 액세스 토큰 요청
    const tokenResponse = await axios.post(
      'https://kauth.kakao.com/oauth/token',
      null,
      {
        params: {
          grant_type: 'authorization_code',
          client_id: 'e05b6c085a959c7d6bd778fa7d4b5a0e', // 여기에 카카오 클라이언트 ID를 입력하세요.
          redirect_uri: 'http://192.168.219.161:3000/auth/kakao/callback',
          code: code,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    );

    const accessToken = tokenResponse.data.access_token;
    console.log(tokenResponse.data);

    // 액세스 토큰을 Flutter 앱에 전달
    res.redirect(`/?token=${accessToken}`);
  } catch (error) {
    console.error('Error fetching token from Kakao:', error);
    res.redirect('/');
  }
});

// 구글 로그인 라우터
router.get('/google', logMiddleware, passport.authenticate('google', { scope: ['profile', 'email'] }));

// 구글 로그인 콜백 라우터
// 구글 로그인 콜백 라우터
router.get('/google/callback', async (req, res, next) => {
  const { code } = req.query;
  console.log("code", req.query);

  try {
    // 구글에 인증 코드를 사용하여 액세스 토큰 요청
    const tokenResponse = await axios.post(
      'https://oauth2.googleapis.com/token',
      new URLSearchParams({
        code: code,
        client_id: '616087438747-ung3nfv8jhg81uilk4bvjs5jbc8aln6o.apps.googleusercontent.com', // 여기에 구글 클라이언트 ID를 입력하세요.
        client_secret: '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', // 여기에 구글 클라이언트 시크릿을 입력하세요.
        redirect_uri: 'http://192.168.219.161:3000/auth/google/callback',
        grant_type: 'authorization_code',
      }),
      {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    );

    const accessToken = tokenResponse.data.access_token;
    console.log(tokenResponse.data);

    // 액세스 토큰을 Flutter 앱에 전달
    res.redirect(`/?token=${accessToken}`);
  } catch (error) {
    console.error('Error fetching token from Google:', error);
    res.redirect('/');
  }
});


module.exports = router;
