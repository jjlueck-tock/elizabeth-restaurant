// web.js
var express = require("express");
var logfmt = require("logfmt");
var path = require('path');
var nodemailer = require("nodemailer");
var app = express();
var bodyParser = require('body-parser')
app.use(bodyParser.urlencoded())

app.use(logfmt.requestLogger());
var APP_RELATIVE_PATH = path.join(__dirname, '/public');
app.use(express.static(APP_RELATIVE_PATH));


app.get('/', function(req, res) {
  res.redirect('index.html');
});

var port = Number(process.env.PORT || 8080);
app.listen(port, function() {
  console.log("Listening on " + port);
  console.log("Emailing from  " + process.env.email);
});

app.post('/comments', function(req, res) {
	console.log(req.body.Email);
  var smtpTransport = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
      user: process.env.email, // michael
      pass: process.env.email_pw
    }
  });

  var mailOptions = {
    from: "Elizabeth website comments <" + req.body.Email + ">",
    to: [process.env.send_to],
    subject: "New website comment from " + req.body.Subject,
    replyTo: req.body.Email,
    text: "Email sent from: " + req.body.Email + '. ' + req.body.Message
  };
  console.log('Sending email');
  smtpTransport.sendMail(mailOptions, function(error, response) {
      try {
        if (error){
          console.log(error);
	  console.log('email error');
	} else{
	  console.log('email sent');
	}
      } catch(e) {
	console.log('EXCEPTION when sending email:' + e);
      }
  });

  res.statusCode = 200;
  res.redirect('index.html');
});
