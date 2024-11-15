import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stylesyncapp/helpers/error_handling.dart';
import 'package:stylesyncapp/utils/constants.dart';
import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/utils/showSnackBar.dart';

class SearchServices {
  Future<List<Designer>> fetchDesigners({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Designer> designersList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$serverURL/api/designers/search/$searchQuery'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            final designerData = jsonDecode(res.body)[i];
            designersList.add(
              Designer.fromMap(designerData),
            );
          }
          print(designersList);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return designersList;
  }
}
