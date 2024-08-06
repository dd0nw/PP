const nodemailer = require('nodemailer');
require('dotenv').config(); 

let transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

function sendEmail(to, subject, text) {
  let mailOptions = {
    from: process.env.EMAIL_USER,
    to: to,
    subject: subject,
    text: text
  };

  return transporter.sendMail(mailOptions);
}

module.exports = {
  sendEmail
};
