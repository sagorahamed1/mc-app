import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/core/routes/app_routes.dart';
import 'package:mc/shared/widgets/custom_network_image.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_text.dart';
import 'package:mc/shared/widgets/custom_text_field.dart';

import 'package:mc/core/utils/app_colors.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            decoration: const BoxDecoration(
                color: Color(0xffEBEBEB), shape: BoxShape.circle),
            child: const Center(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: CustomText(
            text: "Products", fontSize: 18.h, fontWeight: FontWeight.w500),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        child: CustomButtonGradiant(title: "PLACE ORDER", onpress: (){

          Get.toNamed(AppRoutes.confirmOrderScreen);

        }),
      ),


      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Store details", fontSize: 12.h, top: 20.h),
              CustomText(text: "Alexandra Store", fontSize: 16.h),
              CustomText(text: "#125121", fontSize: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: 16.h),
                  SizedBox(width: 4.w),
                  CustomText(
                      text: "5th Nouth Avenue, Baridhara HOHS",
                      textAlign: TextAlign.start),
                ],
              ),
              SizedBox(height: 20.h),
              CustomText(text: "Select Product & Quantity", bottom: 12.h),
              CustomTextField(
                  controller: searchCtrl,
                  hintText: "Search Product",
          
          
                  validator: (value) {}),
          
          
          
          
          
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 70.h, top: 4.h),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                ),
              ),
          
          
          
        
          
          
            ],
          ),
        ),
      ),
    );
  }


  final List<Product> products = [
    Product(
      name: "CokaCola",
      price: 46,
      sku: "#215478",
      category: "Beverages",
      lastOrder: "12 Jan 25",
      units: 23,
      imageUrl: "https://www.simplilearn.com/ice9/free_resources_article_thumb/Coca_Cola_Marketing_Strategy_2022.jpg",
    ),
    Product(
      name: "CokaCola",
      price: 46,
      sku: "#215478",
      category: "Beverages",
      lastOrder: "12 Jan 25",
      units: 23,
      imageUrl: "https://www.simplilearn.com/ice9/free_resources_article_thumb/Coca_Cola_Marketing_Strategy_2022.jpg",
    ),
    Product(
      name: "CokaCola",
      price: 46,
      sku: "#215478",
      category: "Beverages",
      lastOrder: "12 Jan 25",
      units: 23,
      imageUrl: "https://www.simplilearn.com/ice9/free_resources_article_thumb/Coca_Cola_Marketing_Strategy_2022.jpg",
    ),
  ];


}





class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              imageUrl: product.imageUrl,
              width: 121.w,
              height: 150.h,
              borderRadius: BorderRadius.circular(8.r),
            ),
            SizedBox(width: 16.w),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Row(
                    children: [
                      CustomText(
                        text: product.name,
                        fontSize: 18.sp
                      ),

                      const Spacer(),


                      const Radio(value: true)

                    ],
                  ),

                  // Price
                  CustomText(
                    text: "Price: \$${product.price}",
                    fontSize: 10.h
                  ),
                  SizedBox(height: 4.h),

                  // SKU
                  CustomText(
                    text: "SKU NO.: ${product.sku}",
                    fontSize: 12.h
                  ),
                  SizedBox(height: 4.h),

                  // Category
                  CustomText(
                    text: "Category: ${product.category}",
                    fontSize: 12.h
                  ),


                  SizedBox(height: 4.h),

                  SizedBox(
                    height: 32.h,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 13.h),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                        hintText: "Type here....",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)), // <-- Border radius
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          borderSide: const BorderSide(color: Colors.grey), // normal border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          borderSide: const BorderSide(color: Colors.blue), // focused border
                        ),
                      ),
                    ),
                  ),



                  CustomText(
                    text: "Last order: 12 Jan 2025",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    textAlign: TextAlign.left,
                    left: 0,
                  ),


                  CustomText(
                    text: "Buy: 23 Unit",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    textAlign: TextAlign.left,
                    left: 0,
                  ),



                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class Product {
  final String name;
  final double price;
  final String sku;
  final String category;
  final String lastOrder;
  final int units;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.sku,
    required this.category,
    required this.lastOrder,
    required this.units,
    required this.imageUrl,
  });
}



