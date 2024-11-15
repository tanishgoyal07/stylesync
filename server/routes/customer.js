const express = require("express");
const customerRouter = express.Router();
const bcrypt = require("bcryptjs");
const { Customer } = require("../models/customer");
const jwt = require("jsonwebtoken");

const JWT_SECRET = "stylesyncsecret34";

// Customer Signup
customerRouter.post("/api/customers/signup", async (req, res) => {
  try {
    const { name, imageUrl, email, contact, age, gender, password } = req.body;

    if (!name || !email || !contact || !age || !gender || !password) {
      return res.status(400).json({ error: "All fields must be filled" });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: "Invalid email format" });
    }

    const existingCustomer = await Customer.findOne({ email });
    if (existingCustomer) {
      return res.status(400).json({ error: "Email is already registered" });
    }

    if (password.length < 8 || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
      return res.status(400).json({
        error: "Password must be at least 8 characters long, include one uppercase letter and one number",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newCustomer = new Customer({
      name,
      imageUrl,
      email,
      contact,
      age,
      gender,
      password: hashedPassword,
    });

    await newCustomer.save();
    res.status(201).json({ message: "Customer account created successfully" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Customer Login
customerRouter.post("/api/customers/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: "All fields must be filled" });
    }

    const customer = await Customer.findOne({ email });
    if (!customer) {
      return res.status(404).json({ error: "No account found with this email" });
    }

    const isMatch = await bcrypt.compare(password, customer.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign({ id: customer._id, role: "customer" }, JWT_SECRET, { expiresIn: "1h" });

    res.status(200).json({ token, customer });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = customerRouter;
