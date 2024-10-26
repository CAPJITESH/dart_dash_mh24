import 'package:blockchain_upi/constants.dart';
import 'package:blockchain_upi/screens/Bottom%20nav/bottom_nav_item.dart';
import 'package:blockchain_upi/screens/HOME_NEW/home_new.dart';
import 'package:blockchain_upi/screens/Home/home.dart';
import 'package:blockchain_upi/screens/Profile/profile.dart';
import 'package:blockchain_upi/screens/Trading/trading.dart';
import 'package:blockchain_upi/screens/wallet/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:toastification/toastification.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool keyboard = false;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      if (_pageController.page == 0) {
        currentBackPressTime = now;
        toastification.show(
          context: context,
          title: 'Tap on back again to close',
          alignment: const Alignment(0.5, 0.9),
          showProgressBar: false,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        _setPage(0);
      }

      return Future.value(false);
    }
    return Future.value(true);
  }

  bool actionIcon = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          height: 60,
          color: bg1,
          padding: EdgeInsets.zero,
          notchMargin: 8,
          shadowColor: black2,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomNavItem(
                  name: "Home",
                  iconData: Icons.home_rounded,
                  isSelected: _pageIndex == 0,
                  onTap: () => _setPage(0),
                ),
                BottomNavItem(
                  name: "Wallet",
                  iconData: CupertinoIcons.person_2_fill,
                  isSelected: _pageIndex == 1,
                  onTap: () => _setPage(1),
                ),
                BottomNavItem(
                  name: "Trade",
                  iconData: Icons.query_stats_rounded,
                  isSelected: _pageIndex == 2,
                  onTap: () => _setPage(2),
                ),
                BottomNavItem(
                  name: "Profile",
                  iconData: Icons.person,
                  isSelected: _pageIndex == 3,
                  onTap: () => _setPage(3),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const [
            HomeScreenNew(),
            WalletPage(),
            TradePage(),
            Profile()
            //CreateAccount(),
          ],
        ),
      ),
    );
  }
}
