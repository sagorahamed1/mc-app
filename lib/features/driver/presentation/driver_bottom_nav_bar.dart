

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mc/features/driver/presentation/controllers/driver_controller.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/profile/presentation/profile_screen.dart';
import 'package:mc/features/driver/presentation/driver_home_screen.dart';
import 'package:mc/features/driver/presentation/driver_order_screen.dart';


class DriverBottomNavBar extends StatefulWidget {
  @override
  _DriverBottomNavBarState createState() => _DriverBottomNavBarState();
}

class _DriverBottomNavBarState extends State<DriverBottomNavBar> {
  int _selectedIndex = 0;
  final DriverController _ctrl = Get.find<DriverController>();

  static const List<Widget> _widgetOptions = <Widget>[
    DriverHomeScreen(),
    DriverOrderScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _ctrl.fetchDashboard();
      _ctrl.loadUpcomingOrders();
    } else if (index == 1) {
      _ctrl.loadOrderScreenOrders(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem( _selectedIndex == 0 ? Assets.icons.homeIcon.svg() : Assets.icons.homeUnselect.svg(), "Home", 0),
              _buildNavItem(_selectedIndex == 1 ? Assets.icons.orderSelect.svg() : Assets.icons.orderUnselect.svg(), "Order", 1),
              _buildNavItem(_selectedIndex == 2 ? Assets.icons.profileSelect.svg() : Assets.icons.profileUnselect.svg(), "Profile", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(Widget icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          icon,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primaryColor : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
