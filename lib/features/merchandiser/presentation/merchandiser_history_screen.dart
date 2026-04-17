

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc/shared/widgets/custom_schedule_card.dart';
import 'package:mc/shared/widgets/custom_text.dart';

class MerchandiserHistoryScreen extends StatefulWidget {
  const MerchandiserHistoryScreen({super.key});

  @override
  State<MerchandiserHistoryScreen> createState() =>
      _MerchandiserHistoryScreenState();
}

class _MerchandiserHistoryScreenState
    extends State<MerchandiserHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const SizedBox(),
          title: CustomText(
              text: "Order History",
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


                    id: "987654",
                    status: "Delivered",
                    storeName: "Downtown Pet Care",
                    address: "22 Lakeview Road, Banani",
                    schedule: "10:30 AM - 12:00 PM",
                    lastVisited: "10/08/25 at 11:30 AM",
                    startWithin: "0",
                    btnName: "See Order",
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


