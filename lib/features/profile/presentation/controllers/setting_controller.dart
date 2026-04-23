import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/services/api_service.dart';

class SettingController extends GetxController {
  final RxString content = ''.obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchContent(String key) async {
    isLoading(true);
    content('');
    try {
      final response = await ApiClient.getData(ApiConstants.settingContent(key));
      if (response.statusCode == 200) {
        content(response.body['data']?['value'] ?? '');
      }
    } catch (e) {
      debugPrint('Setting fetch error: $e');
    } finally {
      isLoading(false);
    }
  }
}
