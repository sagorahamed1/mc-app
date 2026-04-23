import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/order_model.dart';

class WarehouseOrderController extends GetxController {
  // ── Pending orders ──────────────────────────────────────────────────
  final RxList<OrderModel> pendingOrders = <OrderModel>[].obs;
  final RxBool isPendingLoading = false.obs;
  final RxBool isPendingPaginationLoading = false.obs;
  final ScrollController pendingScrollController = ScrollController();
  int _pendingPage = 1;
  bool _pendingHasMore = true;

  // ── Completed orders ─────────────────────────────────────────────────
  final RxList<OrderModel> completedOrders = <OrderModel>[].obs;
  final RxBool isCompletedLoading = false.obs;
  final RxBool isCompletedPaginationLoading = false.obs;
  final ScrollController completedScrollController = ScrollController();
  int _completedPage = 1;
  bool _completedHasMore = true;

  // ── All orders (All Orders screen, paginated) ─────────────────────────
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxBool isAllOrdersLoading = false.obs;
  final RxBool isAllOrdersPaginationLoading = false.obs;
  final ScrollController allOrdersScrollController = ScrollController();
  int _allOrdersPage = 1;
  bool _allOrdersHasMore = true;

  // ── Recent orders (home screen) ───────────────────────────────────────
  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;
  final RxBool isRecentLoading = false.obs;

  // ── Dashboard summary ─────────────────────────────────────────────────
  final RxInt dashPending = 0.obs;
  final RxInt dashCompleted = 0.obs;
  final RxInt dashTotalUnits = 0.obs;
  final RxDouble dashAvgMark = 0.0.obs;
  final RxBool isDashboardLoading = false.obs;

  static const int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    pendingScrollController.addListener(_onPendingScroll);
    completedScrollController.addListener(_onCompletedScroll);
    allOrdersScrollController.addListener(_onAllOrdersScroll);
    loadPendingOrders();
    loadCompletedOrders();
    loadRecentOrders();
    fetchDashboard();
  }

  @override
  void onClose() {
    pendingScrollController.dispose();
    completedScrollController.dispose();
    allOrdersScrollController.dispose();
    super.onClose();
  }

  void _onPendingScroll() {
    if (pendingScrollController.position.pixels >=
            pendingScrollController.position.maxScrollExtent - 200 &&
        !isPendingPaginationLoading.value &&
        _pendingHasMore) {
      _fetchOrders(
        page: _pendingPage + 1,
        status: 'pending',
        list: pendingOrders,
        append: true,
        pageRef: (p) => _pendingPage = p,
        hasMoreRef: (v) => _pendingHasMore = v,
        paginationLoading: isPendingPaginationLoading,
      );
    }
  }

  void _onAllOrdersScroll() {
    if (allOrdersScrollController.position.pixels >=
            allOrdersScrollController.position.maxScrollExtent - 200 &&
        !isAllOrdersPaginationLoading.value &&
        _allOrdersHasMore) {
      _fetchOrders(
        page: _allOrdersPage + 1,
        list: allOrders,
        append: true,
        pageRef: (p) => _allOrdersPage = p,
        hasMoreRef: (v) => _allOrdersHasMore = v,
        paginationLoading: isAllOrdersPaginationLoading,
      );
    }
  }

  void _onCompletedScroll() {
    if (completedScrollController.position.pixels >=
            completedScrollController.position.maxScrollExtent - 200 &&
        !isCompletedPaginationLoading.value &&
        _completedHasMore) {
      _fetchOrders(
        page: _completedPage + 1,
        status: 'completed',
        list: completedOrders,
        append: true,
        pageRef: (p) => _completedPage = p,
        hasMoreRef: (v) => _completedHasMore = v,
        paginationLoading: isCompletedPaginationLoading,
      );
    }
  }

  Future<void> loadPendingOrders({bool refresh = false}) async {
    if (refresh) {
      _pendingPage = 1;
      _pendingHasMore = true;
      pendingOrders.clear();
    }
    await _fetchOrders(
      page: 1,
      status: 'pending',
      list: pendingOrders,
      append: false,
      pageRef: (p) => _pendingPage = p,
      hasMoreRef: (v) => _pendingHasMore = v,
      mainLoading: isPendingLoading,
      paginationLoading: isPendingPaginationLoading,
    );
  }

  Future<void> loadAllOrders({bool refresh = false}) async {
    if (refresh) {
      _allOrdersPage = 1;
      _allOrdersHasMore = true;
      allOrders.clear();
    }
    await _fetchOrders(
      page: 1,
      list: allOrders,
      append: false,
      pageRef: (p) => _allOrdersPage = p,
      hasMoreRef: (v) => _allOrdersHasMore = v,
      mainLoading: isAllOrdersLoading,
      paginationLoading: isAllOrdersPaginationLoading,
    );
  }

  Future<void> loadCompletedOrders({bool refresh = false}) async {
    if (refresh) {
      _completedPage = 1;
      _completedHasMore = true;
      completedOrders.clear();
    }
    await _fetchOrders(
      page: 1,
      status: 'completed',
      list: completedOrders,
      append: false,
      pageRef: (p) => _completedPage = p,
      hasMoreRef: (v) => _completedHasMore = v,
      mainLoading: isCompletedLoading,
      paginationLoading: isCompletedPaginationLoading,
    );
  }

  Future<void> loadRecentOrders() async {
    isRecentLoading(true);
    final response = await ApiClient.getData(
      '${ApiConstants.orderEndPoint}?page=1&limit=5',
    );
    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      recentOrders.assignAll(data.map((e) => OrderModel.fromJson(e)));
    }
    isRecentLoading(false);
  }

  Future<void> _fetchOrders({
    required int page,
    String? status,
    required RxList<OrderModel> list,
    required bool append,
    required void Function(int) pageRef,
    required void Function(bool) hasMoreRef,
    RxBool? mainLoading,
    RxBool? paginationLoading,
  }) async {
    if (!append) mainLoading?.call(true);
    if (append) paginationLoading?.call(true);

    final statusParam = status != null ? '&status=$status' : '';
    final uri =
        '${ApiConstants.orderEndPoint}?page=$page&limit=$_limit$statusParam';
    final response = await ApiClient.getData(uri);

    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      final pagination = response.body['pagination'] ?? {};
      final newOrders = data.map((e) => OrderModel.fromJson(e)).toList();

      if (append) {
        list.addAll(newOrders);
      } else {
        list.assignAll(newOrders);
      }
      pageRef(page);
      hasMoreRef(page < (pagination['totalPages'] ?? 1));
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Failed to load orders',
        title: 'Error',
      );
    }

    if (!append) mainLoading?.call(false);
    if (append) paginationLoading?.call(false);
  }

  Future<void> fetchDashboard() async {
    isDashboardLoading(true);
    final response = await ApiClient.getData(ApiConstants.warehouseDashboard);
    if (response.statusCode == 200) {
      final data = response.body['data'] ?? {};
      dashPending(data['pendingOrders'] ?? 0);
      dashCompleted(data['completedOrders'] ?? 0);
      dashTotalUnits(data['totalUnits'] ?? 0);
      dashAvgMark((data['avgMark'] ?? 0).toDouble());
    }
    isDashboardLoading(false);
  }

  // Summary counts for home screen
  int get pendingCount => pendingOrders.length;
  int get completedCount => completedOrders.length;
}
