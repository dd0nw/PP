const passportKakao = require('./kakaoStrategy');
const passportGoogle = require('./googleStrategy');

module.exports = () => {
  passportKakao();
  passportGoogle();
};
