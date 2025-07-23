const { Firestore } = require('@google-cloud/firestore');
const { IncomingWebhook } = require('@slack/webhook');
const nodemailer = require('nodemailer');

const db = new Firestore();
const slack = new IncomingWebhook(process.env.SLACK_WEBHOOK_URL);

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_APP_PASS,
  },
});

exports.dealsGenerator = async (req, res) => {
  const snapshot = await db.collection('weekly_deals').get();
  const deals = snapshot.docs.map(d => d.data());

  if (req.query.mode === 'json') {
    return res.status(200).json(deals);
  }

  const htmlBody = \`
<h1>Weekly Deals</h1>
<ul>
\${deals.map(d => \`<li><a href="\${d.url}" target="_blank">\${d.title}</a> – \${d.desc || ''}</li>\`).join('')}
</ul>
\`;

  await transporter.sendMail({
    from: \`NeuraFlow Deals <\${process.env.GMAIL_USER}>\`,
    to: process.env.GMAIL_USER,
    subject: 'Your Weekly Deals 🔥',
    html: htmlBody,
  });

  const slackText = '*Weekly Deals*:\\n' +
    deals.map(d => \`• <\${d.url}|\${d.title}>\`).join('\\n');
  await slack.send({ text: slackText });

  res.status(200).send('Deals sent ✓');
};
