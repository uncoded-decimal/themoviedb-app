import 'package:flutter/material.dart';
import 'package:wework_challenge/src/app/helpers/app_router.dart';
import 'package:wework_challenge/src/modules/splash/models/app_location_data_model.dart';

class IntentHelper {
  static Future<void> goToHome({
    required BuildContext context,
    required LocationDataModel data,
  }) async {
    Navigator.popAndPushNamed(
      context,
      Routes.home,
      arguments: data,
    );
  }
}
