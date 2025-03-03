const express = require("express");
const app = express();
require("dotenv").config();
const path = require("path");

//router
const routerAccount = require("./routes/api/accountRouter");
const routerUser = require("./routes/api/userRouter");
const routerCustomer = require("./routes/api/customerRouter");

const host = process.env.HOST;
const port = process.env.PORT;

//middleware to parse json and urlencoded request body
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

//api route account
app.use("/api/account", routerAccount);
app.use("/api/user", routerUser);
app.use("/api/customer", routerCustomer);
app.use("*", (req, res) => {
  res.status(404).send("What you are looking for is not here!");
});

app.listen(port, () => {
  console.log(`Server listening at http://${host}:${port}`);
});
