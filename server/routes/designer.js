const express = require("express");
const designerRouter = express.Router();
const { Designer } = require("../models/designer");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const JWT_SECRET = "stylesyncsecret34";

// Designer Signup
designerRouter.post("/api/designers/signup", async (req, res) => {
  try {
    const {
      name,
      imageUrl,
      availability,
      ageGroup,
      expertCategory,
      expertSubCategory,
      experiencedIn,
      averagePricing,
      totalCustomersServed,
      email,
      password,
    } = req.body;

    if (!name || !availability || !email || !password || !expertCategory || !expertSubCategory || !ageGroup || !averagePricing || !experiencedIn || !totalCustomersServed) {
      return res.status(400).json({ error: "All required fields must be filled" });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: "Invalid email format" });
    }

    const existingDesigner = await Designer.findOne({ email });
    if (existingDesigner) {
      return res.status(400).json({ error: "Email is already registered" });
    }

    if (password.length < 8 || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
      return res.status(400).json({
        error: "Password must be at least 8 characters long, include one uppercase letter and one number",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newDesigner = new Designer({
      name,
      availability,
      ageGroup,
      expertCategory,
      expertSubCategory,
      experiencedIn,
      averagePricing,
      totalCustomersServed,
      imageUrl,
      email,
      password: hashedPassword,
    });

    await newDesigner.save();
    res.status(201).json({ message: "Designer account created successfully" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Designer Login
designerRouter.post("/api/designers/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: "All fields must be filled" });
    }

    const designer = await Designer.findOne({ email });
    if (!designer) {
      return res.status(404).json({ error: "No account found with this email" });
    }

    const isMatch = await bcrypt.compare(password, designer.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign({ id: designer._id, role: "designer" }, JWT_SECRET, { expiresIn: "1h" });

    res.status(200).json({ token, designer });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//designer search
designerRouter.get("/api/designers/search/:name", async (req, res) => {
  try {
    const searchName = req.params.name.trim();
    const regex = new RegExp(searchName, "i");

    const designers = await Designer.find({
      name: { $regex: regex },
    });

    console.log("Designers Found: ", designers);
    res.json(designers);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = designerRouter;
