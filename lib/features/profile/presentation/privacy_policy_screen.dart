import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class PrivacyPolicyAllScreen extends StatefulWidget {
  const PrivacyPolicyAllScreen({super.key});

  @override
  State<PrivacyPolicyAllScreen> createState() => _PrivacyPolicyAllScreenState();
}

class _PrivacyPolicyAllScreenState extends State<PrivacyPolicyAllScreen> {
  // PrivacyPolicyController policyController = Get.put(PrivacyPolicyController());

  @override
  void initState() {
    // policyController.getPrivacyPolicyAll(
    //     url: Get.arguments["title"] == "Terms of service"
    //         ? "/terms" :  Get.arguments["title"] == "Privacy Policy"
    //         ? "/privacy" : "/about");
    super.initState();
  }

  @override
  void dispose() {
    // policyController.valueText.value = "";
    super.dispose();
  }

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
              text: "${Get.arguments["title"]}",
              fontWeight: FontWeight.w500,
              fontSize: 18.h)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child:
          // Obx(
          //   () => policyController.valueText.isEmpty
          //       ? Center(child: CircularProgressIndicator())
          //       :

            Column(
                    children: [
                      SizedBox(height: 20.h),

                      CustomText(
                        color: Colors.black,
                        maxline: 1000,
                        textAlign: TextAlign.start,
                        text: "Lorem ipsum dolor sit amet consectetur. Lacus at venenatis gravida vivamus mauris. Quisque mi est vel dis. Donec rhoncus laoreet odio orci sed risus elit accumsan. Mattis ut est tristique amet vitae at aliquet. Ac vel porttitor egestas scelerisque enim quisque senectus. Euismod ultricies vulputate id cras bibendum sollicitudin proin odio bibendum. Velit velit in scelerisque erat etiam rutrum phasellus nunc. Sed lectus sed a at et eget. Nunc purus sed quis at risus. Consectetur nibh justo proin placerat condimentum id at adipiscing.Vel blandit mi nulla sodales consectetur. Egestas tristique ultrices gravida duis nisl odio. Posuere curabitur eu platea pellentesque ut. Facilisi elementum neque mauris facilisis in. Cursus condimentum ipsum pretium consequat turpis at porttitor nisi.Scelerisque tellus praesent condimentum euismod a faucibus. Auctor at ultricies at urna aliquam massa pellentesque. Vitae vulputate nullam diam placerat at magna egestas. Lectus lectus consequat porta lectus purus. Nulla duis sem sit at imperdiet lobortis dui. Nunc tellus cursus maecenas phasellus sollicitudin donec dictum. Sodales in faucibus libero augue vestibulum urna mattis curabitur. Sed nullam consectetur euismod a laoreet dui. Nulla porttitor urna id blandit.Pretium pulvinar morbi suspendisse mattis.",
                      )

                      // HtmlWidget(
                      //     "${policyController.valueText.value}",
                      //     textStyle: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       color: Colors.black,
                      //       fontSize: 14.h,
                      //
                      //     )
                      // ),
                    ],
                  ),
          ),
        ),
      // ),
    );
  }
}
