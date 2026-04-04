const express = require("express");
const axios = require("axios");

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.set("view engine", "ejs");

const BACKEND_URL = "http://backend-service:5000";

app.get("/", (req, res) => {
  res.render("form", { error: null });
});

app.get("/test",(req, res)=>{
  return axios.get(`${BACKEND_URL}/test`).then(response => {
    res.send(`Test successful, inserted ID: ${response.data.inserted_id}`);
  }).catch(err => {
    res.send(`Test failed: ${err.message}`);
  });
})

app.post("/submit", async (req, res) => {
  try {
    if (!req.body) {
      return res.render("form", { error: "No data provided" });
    }
    const response = await axios.post(`${BACKEND_URL}/submit`, req.body); // use backend if in Docker
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