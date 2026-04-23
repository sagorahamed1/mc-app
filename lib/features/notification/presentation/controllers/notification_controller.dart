import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/features/notification/data/models/notification_model.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  int _page = 1;
  bool _hasMore = true;
  static const int _limit = 11;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    loadNotifications();
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
      _fetch(page: _page + 1, append: true);
    }
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      notifications.clear();
    }
    await _fetch(page: 1, append: false);
  }

  Future<void> _fetch({required int page, required bool append}) async {
    if (!append) isLoading(true);
    if (append) isPaginationLoading(true);

    try {
      final uri =
          '${ApiConstants.notificationEndPoint}?page=$page&limit=$_limit';
      final response = await ApiClient.getData(uri);

      if (response.statusCode == 200) {
        final data = (response.body['data'] as List?) ?? [];
        final pagination = response.body['pagination'] ?? {};
        final items =
            data.map((e) => NotificationModel.fromJson(e)).toList();

        if (append) {
          notifications.addAll(items);
        } else {
          notifications.assignAll(items);
        }
        _page = page;
        _hasMore = page < (pagination['totalPages'] ?? 1);
      }
    } catch (e) {
      debugPrint('Notification fetch error: $e');
    } finally {
      if (!append) isLoading(false);
      if (append) isPaginationLoading(false);
    }
  }
}
