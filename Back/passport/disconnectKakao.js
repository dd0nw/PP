const axios = require('axios');

async function disconnectKakao(accessToken) {
  const kakaoUnlinkUrl = 'https://kapi.kakao.com/v1/user/unlink';
  try {
    const response = await axios.post(kakaoUnlinkUrl, null, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error disconnecting Kakao:', error.message);
    throw new Error('Failed to disconnect Kakao');
  }
}

module.exports = { disconnectKakao };
