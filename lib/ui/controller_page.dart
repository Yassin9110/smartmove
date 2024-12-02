

import 'package:flutter/material.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
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
        return  AudioRecorderPlayerPage();
      case 1:
        return  HealthStatusWidget();

      default:
        return  HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedPage(),
      bottomNavigationBar: ResponsiveNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: changeTab,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'title',
        ),
        backgroundColor: Colors.grey[850],
        navigationBarButtons: <NavigationBarButton>[
          NavigationBarButton(
            text: 'Home',
            icon: Icons.home,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
          ),
          NavigationBarButton(
            text: 'Alarms',
            icon: Icons.alarm,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
          ),

          NavigationBarButton(
            text: 'Contact',
            icon: Icons.person,
            backgroundGradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
          ),
        ],
      ),
    );
  }
}
