const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const connectToOracle = require('../config/db');
const jwt = require('jsonwebtoken');

module.exports = () => {
  passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: process.env.GOOGLE_CALLBACK_URL
  }, async (accessToken, refreshToken, profile, done) => {
    const connection = await connectToOracle();
    try {
      const { id, displayName, emails } = profile;
      const email = emails[0].value;

      let user = await connection.execute(
        'SELECT * FROM TB_USER WHERE EMAIL = :email',
        { email }
      );

      if (user.rows.length === 0) {
        await connection.execute(
          `INSERT INTO TB_USER (ID, EMAIL, NAME, PROVIDER) VALUES (:id, :email, :name, 'google')`,
          { id, email, name: displayName }
        );
        await connection.commit();
        console.log('New user created:', { id, email, name: displayName });

        // 다시 조회하여 새로 생성된 유저 정보를 가져옴
        user = await connection.execute(
          'SELECT * FROM TB_USER WHERE EMAIL = :email',
          { email }
        );
      } else {
        console.log('Existing user:', user.rows[0]);
      }

      // JWT 토큰 생성
      const token = jwt.sign({ id: user.rows[0][0] }, process.env.JWT_SECRET, {
        expiresIn: '1d'
      });

      done(null, { token });
    } catch (err) {
      done(err);
    } finally {
      await connection.close();
    }
  }));

  passport.serializeUser((user, done) => {
    done(null, user);
  });

  passport.deserializeUser((obj, done) => {
    done(null, obj);
  });
};
