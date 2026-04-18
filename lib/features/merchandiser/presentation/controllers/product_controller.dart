import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mc/core/constants/api_constants.dart';
import 'package:mc/core/services/api_service.dart';
import 'package:mc/core/utils/toast_helper.dart';
import 'package:mc/features/merchandiser/data/models/product_model.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<ProductStoreModel?> store = Rx(null);
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxSet<String> selectedIds = <String>{}.obs;

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

  Future<void> loadProducts(String storeId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      products.clear();
      store.value = null;
      selectedIds.clear();
    }
    _storeId = storeId;
    await _fetchPage(1, append: false);
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    if (!append) isLoading(true);
    if (append) isPaginationLoading(true);

    final response = await ApiClient.getData(
      '${ApiConstants.productEndPoint}?page=$page&limit=$_limit&storeId=$_storeId',
    );

    if (response.statusCode == 200) {
      final data = (response.body['data'] as List?) ?? [];
      final pagination = response.body['pagination'] ?? {};
      final extra = response.body['extra'] ?? {};

      final newProducts = data.map((e) => ProductModel.fromJson(e)).toList();

      if (append) {
        products.addAll(newProducts);
      } else {
        products.assignAll(newProducts);
        if (extra['store'] != null) {
          store.value = ProductStoreModel.fromJson(extra['store']);
        }
      }

      _currentPage = page;
      _hasMore = _currentPage < (pagination['totalPages'] ?? 1);
    } else {
      ToastMessageHelper.showToastMessage(
        response.statusText ?? 'Failed to load products',
        title: 'Error',
      );
    }

    if (!append) isLoading(false);
    if (append) isPaginationLoading(false);
  }

  void toggleSelection(String productId) {
    if (selectedIds.contains(productId)) {
      selectedIds.remove(productId);
    } else {
      selectedIds.add(productId);
    }
  }
}
