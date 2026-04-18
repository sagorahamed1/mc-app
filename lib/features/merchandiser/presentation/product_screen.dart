import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/data/models/product_model.dart';
import 'package:mc/features/merchandiser/presentation/controllers/product_controller.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _ctrl = Get.find<ProductController>();
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final storeId = Get.arguments as String? ?? '';
    _ctrl.loadProducts(storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Get.back,
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
                color: Color(0xffEBEBEB), shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.arrow_back)),
          ),
        ),
        title: CustomText(
            text: "Products", fontSize: 18.h, fontWeight: FontWeight.w500),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: CustomButtonGradiant(
          title: "PLACE ORDER",
          onpress: () => Get.toNamed(AppRoutes.confirmOrderScreen),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store details header
              Obx(() {
                final store = _ctrl.store.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: "Store details", fontSize: 12.h, top: 20.h),
                    CustomText(
                        text: store?.name ?? '—', fontSize: 16.h),
                    CustomText(
                        text: store?.id.isNotEmpty == true
                            ? '#${store!.id.substring(store.id.length > 8 ? store.id.length - 8 : 0)}'
                            : '—',
                        fontSize: 12.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16.h),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: CustomText(
                              text: store?.address ?? '—',
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 20.h),
              CustomText(text: "Select Product & Quantity", bottom: 12.h),
              CustomTextField(
                controller: searchCtrl,
                hintText: "Search Product",
                validator: (_) => null,
              ),

              Expanded(
                child: Obx(() {
                  if (_ctrl.isLoading.value && _ctrl.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_ctrl.products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return ListView.builder(
                    controller: _ctrl.scrollController,
                    padding: EdgeInsets.only(bottom: 70.h, top: 4.h),
                    itemCount: _ctrl.products.length +
                        (_ctrl.isPaginationLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _ctrl.products.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = _ctrl.products[index];
                      return Obx(() => ProductCard(
                            product: product,
                            isSelected:
                                _ctrl.selectedIds.contains(product.id),
                            onTap: () => _ctrl.toggleSelection(product.id),
                          ));
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  String _formatLastOrder(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd MMM yy').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              CustomNetworkImage(
                imageUrl: product.logo,
                width: 121.w,
                height: 150.h,
                borderRadius: BorderRadius.circular(8.r),
              ),
              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + radio indicator
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: product.name,
                            fontSize: 18.sp,
                          ),
                        ),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),

                    CustomText(
                        text: "Price: \$${product.price}",
                        fontSize: 10.h),
                    SizedBox(height: 4.h),
                    CustomText(
                        text: "SKU NO.: ${product.itemNo}",
                        fontSize: 12.h),
                    SizedBox(height: 4.h),
                    CustomText(
                        text: "Category: ${product.category}",
                        fontSize: 12.h),
                    SizedBox(height: 4.h),

                    // Quantity input
                    SizedBox(
                      height: 32.h,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 13.h),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.w),
                          hintText: "Type here....",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            borderSide:
                                const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            borderSide:
                                const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),

                    CustomText(
                      text: "Last order: ${_formatLastOrder(product.lastOrderedAt)}",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                    CustomText(
                      text: "Buy: ${product.lastOrderUnit} Unit",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
