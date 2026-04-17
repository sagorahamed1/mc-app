import 'package:flutter/material.dart';
import 'package:mc/global/custom_assets/assets.gen.dart';
import 'package:mc/core/utils/app_colors.dart';
import 'package:mc/features/merchandiser/presentation/merchandiser_home_screen.dart';
import 'package:mc/features/profile/presentation/profile_screen.dart';
import 'package:mc/features/merchandiser/presentation/merchandiser_history_screen.dart';
import 'package:mc/features/merchandiser/presentation/merchandiser_schedule_screen.dart';

class MerchandiserBottomNavBar extends StatefulWidget {
  @override
  _MerchandiserBottomNavBarState createState() => _MerchandiserBottomNavBarState();
}

class _MerchandiserBottomNavBarState extends State<MerchandiserBottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MerchandiserHomeScreen(),
    MerchandiserScheduleScreen(),
    MerchandiserHistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SafeArea(
        child: Container(
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
                _buildNavItem(_selectedIndex == 1 ? Assets.icons.scheduleSelect.svg() : Assets.icons.scheduleUnselect.svg(), "Schedule", 1),
                _buildNavItem(_selectedIndex == 2 ? Assets.icons.orderSelect.svg() : Assets.icons.orderUnselect.svg(), "History", 2),
                _buildNavItem(_selectedIndex == 3 ? Assets.icons.profileSelect.svg() : Assets.icons.profileUnselect.svg(), "Profile", 3),
              ],
            ),
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
