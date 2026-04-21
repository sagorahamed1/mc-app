import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/constants/app_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/services/storage_service.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  static const int _limit = 10;
  bool _hasMore = true;
  String _storeId = '';

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isPaginationLoading.value &&
        _hasMore) {
      _fetchPage(_currentPage + 1, append: true);
    }
  }

  Future<void> loadOrders(String storeId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      orders.clear();
    }
    _storeId = storeId;
    await _fetchPage(1, append: false);
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    if (!append) isLoading(true);
    if (append) isPaginationLoading(true);

    String uri = '${ApiConstants.orderEndPoint}?page=$page&limit=$_limit&status=delivered';
    if (_storeId.isNotEmpty) uri += '&storeId=$_storeId';

    final response = await ApiClient.getData(uri);

    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      final pagination = response.body['pagination'] ?? {};
      final newOrders = data.map((e) => OrderModel.fromJson(e)).toList();

      if (append) {
        orders.addAll(newOrders);
      } else {
        orders.assignAll(newOrders);
      }
      _currentPage = page;
      _hasMore = _currentPage < (pagination['totalPages'] ?? 1);
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Failed to load orders',
        title: 'Error',
      );
    }

    if (!append) isLoading(false);
    if (append) isPaginationLoading(false);
  }

  Future<String?> uploadStickerImage(File image) async {
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.uploadMultiple);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('files', image.path));
    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final decoded = jsonDecode(body);
        final filenames = List<String>.from(decoded['data'] ?? []);
        if (filenames.isNotEmpty) {
          return '${ApiConstants.imageBaseUrl}${filenames.first}';
        }
      }
    } catch (e) {
      debugPrint('Sticker upload error: $e');
    }
    return null;
  }

  Future<bool> submitConfirmation({
    required String orderId,
    required String receiverName,
    required List<String> stickerUrls,
  }) async {
    isSubmitting(true);
    final body = {
      'receiverName': receiverName,
      'stickers': stickerUrls,
    };
    final response = await ApiClient.patch(
      '${ApiConstants.orderEndPoint}/$orderId/confirm-delivery',
      jsonEncode(body),
    );
    isSubmitting(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Failed to submit confirmation',
        title: 'Error',
      );
      return false;
    }
  }
}
