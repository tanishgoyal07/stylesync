const express = require("express");
const mongoose = require("mongoose");

const customerRouter = require("./routes/customer");
const designerRouter = require("./routes/designer");
const logoutRouter = require("./routes/logoutRoutes");
const productRouter = require("./routes/product");

const PORT = process.env.PORT || 3000;
const app = express();
const DB = "mongodb+srv://aryabagla2003:arya1234@cluster0.btyhj.mongodb.net/users?retryWrites=true&w=majority&appName=Cluster0";

app.use(express.json());
app.use(customerRouter);
app.use(designerRouter);
app.use(logoutRouter);
app.use(productRouter);

//Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0" , () => {
  console.log(`connected at port ${PORT}`);
});
