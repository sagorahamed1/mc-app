

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/shared/widgets/custom_button.dart';

import 'package:mc/shared/widgets/custom_text.dart';

class PickListScreen extends StatefulWidget {
  const PickListScreen({super.key});

  @override
  State<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {


  // Dummy data
  final List<Map<String, dynamic>> data = [
    {"name": "Coca_Cola", "strength": 500, "totalTablets": 20},
    {"name": "Coca_Cola ", "strength": 250, "totalTablets": 15},
    {"name": "Coca Cola", "strength": 400, "totalTablets": 10},
    {"name": "CocaCola", "strength": 10, "totalTablets": 30},
    {"name": "Coca _Cola", "strength": 20, "totalTablets": 25},
  ];

  // Selected items with their quantities
  Map<String, int> selectedQuantities = {};


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
                  color: Color(0xffEBEBEB),
                  shape: BoxShape.circle
              ),
              child: const Center(
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          title: CustomText(
              text: "Pick List", fontWeight: FontWeight.w500, fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [



            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                CustomText(text: "Items", fontWeight: FontWeight.w500, color: Color(0xff122E55)),
                CustomText(text: "Inventory", fontWeight: FontWeight.w500, color: Color(0xff122E55)),
                CustomText(text: "Quantity", fontWeight: FontWeight.w500, color: Color(0xff122E55), right: 16.w),

              ],
            ),

            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => SizedBox.shrink(),
                itemBuilder: (context, index) {
                  final medicine = data[index];
                  final isSelected = selectedQuantities.containsKey(
                    medicine["name"],
                  );

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedQuantities[medicine["name"]] =
                              1; // default 1
                            } else {
                              selectedQuantities.remove(medicine["name"]);
                            }
                          });
                        },
                      ),


                      Expanded(
                        child: CustomText(
                          text: "${medicine["name"]} ${medicine["strength"]}ml",
                          fontSize: 10.h,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      Expanded(
                        child: CustomText(
                          text: "Coca Cola",
                          fontSize: 10.h,
                          textAlign: TextAlign.start,
                        ),
                      ),


                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 60.w,
                        height: 35.h,
                        child: TextField(
                          enabled: isSelected,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedQuantities[medicine["name"]] =
                                  int.tryParse(val) ?? 0;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "00",
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: "Out of ${medicine["totalTablets"]}",
                        fontSize: 10.h,
                      ),
                    ],
                  );
                },
              ),
            ),






            CustomButtonGradiant(title: "READY FOR INSPECTION", onpress: (){}),


            SizedBox(height: 80.h)



          ],
        ),
      ),


    );
  }
}
