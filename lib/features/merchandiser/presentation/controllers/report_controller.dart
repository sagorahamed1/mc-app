import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/services/storage_service.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/report_question_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/merchandiser_controller.dart';

class ReportController extends GetxController {
  final RxList<ReportQuestionModel> questions = <ReportQuestionModel>[].obs;
  final RxMap<String, TextEditingController> answerControllers =
      <String, TextEditingController>{}.obs;
  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    for (final c in answerControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  Future<void> loadQuestions() async {
    isLoading(true);
    final response = await ApiClient.getData(ApiConstants.storeReportQuestions);
    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      final loaded = data.map((e) => ReportQuestionModel.fromJson(e)).toList();
      questions.assignAll(loaded);
      for (final q in loaded) {
        if (!answerControllers.containsKey(q.id)) {
          answerControllers[q.id] = TextEditingController();
        }
      }
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Failed to load questions',
        title: 'Error',
      );
    }
    isLoading(false);
  }

  void addImages(List<File> images) {
    selectedImages.addAll(images);
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<List<String>> _uploadImages() async {
    isUploading(true);
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.uploadMultiple);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    for (final file in selectedImages) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }
    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      debugPrint('====> Upload response [${streamed.statusCode}]: $body');
      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final decoded = jsonDecode(body);
        final filenames = List<String>.from(decoded['data'] ?? []);
        final imageUrls = filenames
            .map((f) => '${ApiConstants.imageBaseUrl}$f')
            .toList();
        isUploading(false);
        return imageUrls;
      }
    } catch (e) {
      debugPrint('Upload error: $e');
    }
    isUploading(false);
    ToastMessageHelper.showToastMessage('Image upload failed', title: 'Error');
    return [];
  }

  Future<bool> submitReport(String visitId) async {
    // Fallback: get visitId from MerchandiserController if not passed
    String resolvedVisitId = visitId;
    if (resolvedVisitId.isEmpty) {
      final merch = Get.find<MerchandiserController>();
      resolvedVisitId = merch.visits.isNotEmpty ? merch.visits.first.id : '';
    }

    if (resolvedVisitId.isEmpty) {
      ToastMessageHelper.showToastMessage('Visit ID not found', title: 'Error');
      return false;
    }

    List<String> imageUrls = [];
    if (selectedImages.isNotEmpty) {
      imageUrls = await _uploadImages();
      if (imageUrls.isEmpty && selectedImages.isNotEmpty) return false;
    }

    final qna = questions.map((q) {
      final answer = answerControllers[q.id]?.text.trim() ?? '';
      return {'q': q.question, 'a': answer};
    }).toList();

    isSubmitting(true);
    final body = {'qna': qna, 'images': imageUrls};
    final response = await ApiClient.patch(
        ApiConstants.submitReport(resolvedVisitId), jsonEncode(body));
    isSubmitting(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Failed to submit report',
        title: 'Error',
      );
      return false;
    }
  }
}
