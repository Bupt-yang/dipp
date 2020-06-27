var app = require("./ethereum");

app.initWeb3();
app.initContract();
console.log(app.donationInstance);
