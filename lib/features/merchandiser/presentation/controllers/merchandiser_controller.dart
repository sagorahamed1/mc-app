import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/visit_model.dart';

class MerchandiserController extends GetxController {
  final RxList<VisitModel> visits = <VisitModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxSet<String> loadingIds = <String>{}.obs;

  final ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  static const int _limit = 10;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchVisits();
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

  Future<void> fetchVisits({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      visits.clear();
    }
    isLoading(true);
    await _fetchPage(1, append: false);
    isLoading(false);
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    if (!append) isLoading(true);
    if (append) isPaginationLoading(true);

    final response = await ApiClient.getData(
      '${ApiConstants.merchandiserVisits}?page=$page&limit=$_limit',
    );

    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      final pagination = response.body['pagination'] ?? {};
      final newVisits = data.map((e) => VisitModel.fromJson(e)).toList();

      if (append) {
        visits.addAll(newVisits);
      } else {
        visits.assignAll(newVisits);
      }

      _currentPage = page;
      final totalPages = pagination['totalPages'] ?? 1;
      _hasMore = _currentPage < totalPages;
    } else {
      if (!append) {
        ToastMessageHelper.showToastMessage(
          response.statusText ?? 'Failed to load visits',
          title: 'Error',
        );
      }
    }

    if (!append) isLoading(false);
    if (append) isPaginationLoading(false);
  }

  Future<void> clockIn(String visitId) async {
    loadingIds.add(visitId);
    final response = await ApiClient.patch(
      ApiConstants.visitClockIn(visitId),
      null,
    );
    loadingIds.remove(visitId);

    if (response.statusCode == 200 || response.statusCode == 201) {
      _updateVisitStatus(visitId, 'ongoing', 'Ongoing');
      ToastMessageHelper.showToastMessage('Clocked in successfully');
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Clock in failed',
        title: 'Error',
      );
    }
  }

  Future<void> clockOut(String visitId) async {
    loadingIds.add(visitId);
    final response = await ApiClient.patch(
      ApiConstants.visitClockOut(visitId),
      null,
    );
    loadingIds.remove(visitId);

    if (response.statusCode == 200 || response.statusCode == 201) {
      _updateVisitStatus(visitId, 'completed', 'Completed');
      ToastMessageHelper.showToastMessage('Clocked out successfully');
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Clock out failed',
        title: 'Error',
      );
    }
  }

  Future<void> submitReschedule(String visitId, String reason) async {
    loadingIds.add(visitId);
    final response = await ApiClient.patch(
      ApiConstants.visitReschedule(visitId),
      jsonEncode({"reason": reason}),
    );
    loadingIds.remove(visitId);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage('Reschedule request submitted');
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Reschedule failed',
        title: 'Error',
      );
    }
  }

  void _updateVisitStatus(String visitId, String status, String displayStatus) {
    final idx = visits.indexWhere((v) => v.id == visitId);
    if (idx != -1) {
      visits[idx] = visits[idx].copyWith(
        status: status,
        displayStatus: displayStatus,
      );
      visits.refresh();
    }
  }
}
