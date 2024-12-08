import 'package:flutter/material.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:smart/ui/alarm_page.dart';
import 'package:smart/ui/profile_page.dart';
import 'package:smart/ui/record_page.dart';

import '../../../../core/app_theme.dart';
import 'health_status_widget.dart';
import 'home_screen.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key? key}) : super(key: key);

  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return AudioRecorderPlayerPage();
      case 1:
        return TestConnectionPage();
      case 2:
        return HealthStatusWidget();
      case 3:
        return ProfilePage();
      default:
        return TestConnectionPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the primary color as the Scaffold's background
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Background color layer
          Container(
            color: primaryColor, // Use your theme's primary color
            height: double.infinity,
          ),
          // Main content
          _getSelectedPage(),
        ],
      ),
      bottomNavigationBar: ResponsiveNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: changeTab,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'title',
        ),
        backgroundColor: primaryColor, // Ensure footer matches the theme
        navigationBarButtons: <NavigationBarButton>[
          NavigationBarButton(
            text: 'Home',
            icon: Icons.home,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, Colors.black12],
            ),
          ),
          NavigationBarButton(
            text: 'Alarms',
            icon: Icons.alarm,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, Colors.black12],
            ),
          ),
          NavigationBarButton(
            text: 'Monitor',
            icon: Icons.monitor_heart,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, Colors.black12],
            ),
          ),
          NavigationBarButton(
            text: 'Contact',
            icon: Icons.person,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, Colors.black12],
            ),
          ),
        ],
      ),
    );
  }
}
