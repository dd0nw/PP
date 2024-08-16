const express = require('express');
const passport = require('passport');
const router = express.Router();
const axios = require('axios');
require('dotenv').config();

const KAKAO_CLIENT_ID = process.env.KAKAO_CLIENT_ID;
const KAKAO_CALLBACK_URL = process.env.KAKAO_CALLBACK_URL
const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID
const GOOGLE_CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET
const GOOGLE_CALLBACK_URL = process.env.GOOGLE_CALLBACK_URL


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
          client_id: KAKAO_CLIENT_ID, 
          redirect_uri: KAKAO_CALLBACK_URL,
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
        client_id: GOOGLE_CLIENT_ID,
        client_secret: GOOGLE_CLIENT_SECRET, 
        redirect_uri: GOOGLE_CALLBACK_URL,
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

router.get('/gg',(req,res)=>{
  const gg = req.quergy.gg
  if(gg!=1){
    return res.status(400).json({ error: 'gg=not 1' });
  }
  res.json({gg:'google'});
});


module.exports = router;
