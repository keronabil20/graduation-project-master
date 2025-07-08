// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/menu_grid.dart';

class ThankYouScreen extends StatefulWidget {
  final dynamic restaurantId;

  const ThankYouScreen({super.key, required this.restaurantId});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen>
    with SingleTickerProviderStateMixin {
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
                    'Thank you ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SizedBox(width: 10),
                  Text(
                    "Our kitchen is now preparing your order—fresh and just the way you like it!",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 70,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Press the left button to hold the tablet.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
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
                  'You can continuing order if you want',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
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
