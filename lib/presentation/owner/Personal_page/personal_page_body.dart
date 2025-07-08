// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/User/personal_page/logout.dart';
import 'package:graduation_project/presentation/owner/Personal_page/personal_page_header.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/utils/services/cubit/language_cubit.dart';
import 'package:graduation_project/utils/themes/custom/theme_cubit.dart';

class OwnerPersonalPage extends StatefulWidget {
  final String ownerId;
  final String restaurantId;
  const OwnerPersonalPage(
      {super.key, required this.ownerId, required this.restaurantId});

  @override
  State<OwnerPersonalPage> createState() => _OwnerPersonalPageState();
}

class _OwnerPersonalPageState extends State<OwnerPersonalPage> {
  @override
  Widget build(BuildContext context) {
    // Move theme/text access outside of builders
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header section - doesn't need theme rebuilds
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300.h,
                    child: SvgPicture.asset(
                      'assets/images/personal_page_background.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  OwnerProfileHeader(ownerId: widget.ownerId),
                ],
              ),
            ),
          ),

          // Settings section with selective rebuilds
          _buildSettingsList(textTheme),
        ],
      ),
    );
  }

  Widget _buildSettingsList(TextTheme textTheme) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Language Toggle - only rebuilds when language changes
        BlocBuilder<LocaleCubit, Locale>(
          buildWhen: (prev, current) => prev != current,
          builder: (context, locale) {
            return ListTile(
              leading: Icon(Icons.language, size: 28.sp),
              title: Text(S().language, style: textTheme.bodyLarge),
              trailing: Text(
                locale.languageCode == 'ar' ? 'English' : "العربية",
                style: textTheme.bodyMedium,
              ),
              onTap: () => context.read<LocaleCubit>().toggleLocale(),
            );
          },
        ),

        // Theme Toggle - optimized
        _buildThemeToggle(textTheme),

        // Other options that don't need rebuilds
        _buildOptionTile(
          icon: Icons.favorite,
          label: S().likes,
          onTap: () => Navigator.pushNamed(context, AppRoutes.favoritesPage),
        ),
        _buildOptionTile(
          icon: Icons.menu,
          label: S().menu,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.chooseTablet,
              arguments: widget.restaurantId,
              (route) => false,
            );
          },
        ),
        _buildOptionTile(
          icon: Icons.logout,
          label: S().logout,
          onTap: () => showCustomLogoutDialog(context),
        ),
      ]),
    );
  }

  Widget _buildThemeToggle(TextTheme textTheme) {
    return BlocBuilder<ThemeCubit, bool>(
      buildWhen: (prev, current) => prev != current,
      builder: (context, isDarkMode) {
        return SwitchListTile(
          activeColor: deeporange,
          activeTrackColor: deeporange.withOpacity(0.5),
          inactiveTrackColor: Colors.grey.withOpacity(0.5),
          title: Text(
            isDarkMode ? S().stlight : S().stdark,
            style: textTheme.bodyLarge,
          ),
          secondary: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: 28.sp,
          ),
          value: isDarkMode,
          onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28.sp),
      title: Text(
        label,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
