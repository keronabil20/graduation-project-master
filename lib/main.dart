// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/domain/repo/post/post_repository.dart';
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/auth/sign_up/cubit/auth_cubit.dart';
import 'package:graduation_project/presentation/menu_item/order/cubit/order_cubit.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_bloc.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_bloc.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/cubit/analytics_cubit.dart';
import 'package:graduation_project/presentation/posts/cubit/posts_cubit.dart';
import 'package:graduation_project/presentation/posts/cubit/upload_post_cubit.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/services/cubit/language_cubit.dart';
import 'package:graduation_project/utils/themes/custom/dark_mode.dart';
import 'package:graduation_project/utils/themes/custom/light_mode.dart';
import 'package:graduation_project/utils/themes/custom/theme_cubit.dart';
import 'firebase/firebase_options.dart';

import 'service_locator.dart' as di; // Import DI setup

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependency injection
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.getIt<MenuBloc>()),
        BlocProvider(create: (context) => di.getIt<MenuItemFormBloc>()),
        BlocProvider(create: (context) => di.getIt<ThemeCubit>()),
        BlocProvider(create: (context) => di.getIt<AuthCubit>()),
        BlocProvider(create: (context) => di.getIt<LocaleCubit>()),
        BlocProvider(create: (context) => di.getIt<PostsCubit>()),
        BlocProvider(create: (context) => di.getIt<OrderCubit>()),
        BlocProvider(create: (context) => di.getIt<AnalyticsCubit>()),
        BlocProvider(
          create: (context) => UploadPostCubit(
            postRepository: di.getIt<PostRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDarkMode) {
            return BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp(
                  locale: locale,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  theme: lightMode,
                  darkTheme: darkMode,
                  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: AppRoutes.generateRoute,
                  initialRoute: AppRoutes.splash,
                );
              },
            );
          },
        );
      },
    );
  }
}
