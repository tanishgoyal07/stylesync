import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:stylesyncapp/utils/showSnackBar.dart';

class CloudinaryService {
  final String uploadPreset = "cswcpjyp"; 
  final String cloudName = "dqnso8uuy";

  Future<String> uploadImage(BuildContext context, File image) async {
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: "users"),
      );
      print(res.secureUrl);
      return res.secureUrl;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return "";
  }
}
