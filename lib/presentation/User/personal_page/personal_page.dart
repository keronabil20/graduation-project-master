// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/User/personal_page/logout.dart';
import 'package:graduation_project/presentation/User/personal_page/personal_header.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/utils/services/cubit/language_cubit.dart';
import 'package:graduation_project/utils/themes/custom/theme_cubit.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  String userType = "User"; // Default role

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.of(context).size.width, // Full screen width
              height: 300.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width, // Full screen width
                    height: 300.h,
                    child: SvgPicture.asset(
                      'assets/images/personal_page_background.svg',
                      fit: BoxFit.fill, // This will fill the available space
                    ),
                  ),
                  const ProfileHeader(),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Language Toggle Tile
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, localeState) {
                  return ListTile(
                    leading: Icon(Icons.language, size: 28.sp),
                    title: Text(
                      S().language,
                      style: textTheme.bodyLarge,
                    ),
                    trailing: Text(
                      localeState.languageCode == 'ar' ? 'English' : "العربية",
                      style: textTheme.bodyMedium,
                    ),
                    onTap: () async {
                      context.read<LocaleCubit>().toggleLocale();
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  );
                },
              ),

              // Dark Mode Toggle
              BlocBuilder<ThemeCubit, bool>(
                builder: (context, isDarkMode) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: SwitchListTile(
                      activeColor: deeporange,
                      activeTrackColor: deeporange.withOpacity(0.5),
                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      title: Text(
                        isDarkMode ? S().stlight : S().stdark,
                        style: textTheme.bodyLarge,
                      ),
                      secondary: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                            turns: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          key: ValueKey<bool>(isDarkMode),
                          size: 28.sp,
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        ),
                      ),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                  );
                },
              ),
              _buildOptionTile(
                context,
                icon: Icons.favorite,
                label: S().likes,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.favoritesPage),
              ),
              _buildOptionTile(
                context,
                icon: Icons.logout,
                label: S().logout,
                onTap: () => showCustomLogoutDialog(context),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Settings List Tile Widget
  Widget _buildOptionTile(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, size: 28.sp),
      title: Text(label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
