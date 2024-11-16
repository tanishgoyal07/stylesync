const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  designerName: { type: String, required: true },
  category: { type: String, required: true },
  articleType: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  imageUrls: [{ type: String, required: true }],
  createdAt: { type: Date, default: Date.now },
});

const Product = mongoose.model('Product', productSchema);

module.exports = Product;
