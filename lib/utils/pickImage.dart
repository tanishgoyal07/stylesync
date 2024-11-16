import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();
  
  Future<File?> selectImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        debugPrint("No image selected");
      }
    } catch (e) {
      debugPrint("Error selecting image: $e");
    }
    return null;
  }

  Future<List<File>> selectMultipleImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      } else {
        debugPrint("No images selected");
      }
    } catch (e) {
      debugPrint("Error selecting images: $e");
    }
    return [];
  }
}
