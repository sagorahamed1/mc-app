import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/shared/widgets/custom_button.dart';
import 'package:mc/shared/widgets/custom_schedule_card.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class MerchandiserScheduleScreen extends StatefulWidget {
  const MerchandiserScheduleScreen({super.key});

  @override
  State<MerchandiserScheduleScreen> createState() =>
      _MerchandiserScheduleScreenState();
}

class _MerchandiserScheduleScreenState
    extends State<MerchandiserScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: SizedBox(),
          title: CustomText(
              text: "My Schedule",
              fontWeight: FontWeight.w500,
              fontSize: 18.h)),



      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [


            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final item = [];
                  return CustomScheduleCard(
                    statusColor: item == 'Upcoming'
                        ? const Color(0xff305CDE)
                        : Colors.green,
              
              
                    onClockIn: () {
              
                    },
              
                    btnName: "Chock In",
                    id: "987654",
                    status: "Completed",
                    storeName: "Downtown Pet Care",
                    address: "22 Lakeview Road, Banani",
                    schedule: "10:30 AM - 12:00 PM",
                    lastVisited: "10/08/25 at 11:30 AM",
                    startWithin: "0",
                  );
                },
              ),
            )



          ],
        ),
      ),
    );
  }
}



