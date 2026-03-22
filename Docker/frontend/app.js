const express = require("express");
const axios = require("axios");

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.render("form", { error: null });
});

app.post("/submit", async (req, res) => {
  try {
    if (!req.body) {
      return res.render("form", { error: "No data provided" });
    }
    const response = await axios.post("http://localhost:5000/submit", req.body); // use backend if in Docker
    if (response.status === 200) {
      res.redirect("/success");
    }
  } catch (err) {
    console.log("something went wrong:", err.message);
    res.render("form", { error: err.message });
  }
});

app.get("/success", (req, res) => {
  res.send("Data submitted successfully (via Node frontend)");
});

app.listen(3000, () => {
  console.log("Frontend server is running on port 3000");
});