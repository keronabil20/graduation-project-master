import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/menu_grid.dart';
import 'package:graduation_project/utils/services/flages.dart';

class ChooseTableScreen extends StatefulWidget {
  final String restaurantId;

  const ChooseTableScreen({super.key, required this.restaurantId});

  @override
  _ChooseTableScreenState createState() => _ChooseTableScreenState();
}

class _ChooseTableScreenState extends State<ChooseTableScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SVG background instead of gradient
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/robot_order_background.svg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 20,
            left: 30,
            right: 30,
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 40),
                const SizedBox(width: 10),
                const Text(
                  'Powered by Revo',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to our restaurant',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Press the right button to get the tablet.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.touch_app,
                        size: 70,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'you can open the menu by pressing the button below',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    GlobalFlags.isFromTablet = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuGrid(
                          restaurantId: widget.restaurantId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.restaurant_menu, color: Colors.white),
                  label: Text(
                    'Menu',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
