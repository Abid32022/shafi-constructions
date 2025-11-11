import 'package:construction_website/documents_viewer_screen.dart';
import 'package:construction_website/project_gallery_screen.dart';
import 'package:construction_website/web_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ConstructionPortfolioApp());
}

class ConstructionPortfolioApp extends StatelessWidget {
  const ConstructionPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080), // Design size for desktop/web
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'MS Shafi Ullah Construction',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF0F0E47),
            scaffoldBackgroundColor: const Color(0xFF272757),
            fontFamily: 'Poppins',
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headlineMedium: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF8686AC),
              ),
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
