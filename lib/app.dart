import 'package:e_com/views/auth/login_screen.dart';
import 'package:e_com/views/auth/register_screen.dart';
import 'package:e_com/views/auth/splash_screen.dart';
import 'package:e_com/views/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'features/theme/theme_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit()..loadTheme(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,

          initialRoute: '/',   // 👈 Start with login
          getPages: [
            GetPage(name: "/", page: () => SplashScreen()),
            GetPage(name: "/login", page: () => LoginScreen()),
            GetPage(name: "/register", page: () => RegisterScreen()),
            GetPage(name: "/home", page: () => HomeScreen()),
          ],
        );
      },
    );
  }
}