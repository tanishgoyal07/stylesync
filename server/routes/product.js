const express = require('express')
const Product = require('../models/product')
const productRouter = express.Router()

productRouter.post('/api/upload-design', async (req, res) => {
  const {
    designerName,
    category,
    articleType,
    description,
    price,
    imageUrls,
  } = req.body

  try {
    const newProduct = new Product({
      designerName,
      category,
      articleType,
      description,
      price,
      imageUrls,
    })

    await newProduct.save()

    res.status(201).json({
      message: 'Product uploaded successfully',
      product: newProduct,
    })
  } catch (err) {
    console.error(err)
    res.status(500).json({ message: 'Failed to upload product' })
  }
})

productRouter.get('/api/designs', async (req, res) => {
  try {
    const products = await Product.find()
    res.status(200).json(products)
  } catch (err) {
    console.error(err)
    res.status(500).json({ message: 'Failed to fetch products' })
  }
})

module.exports = productRouter
