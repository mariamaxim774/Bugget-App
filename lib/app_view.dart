import 'package:flutter/material.dart';
import './screens/home/views/homescreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//folosesc teme diferite pentru web si pentru android
class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme:buildAdaptiveTheme() ,
      home: HomeScreen(),
    );
  }
  ThemeData buildAdaptiveTheme() {
    if (kIsWeb) {
      return buildWebTheme();
    } else {
      return buildAndroidTheme();
    }
  }

  ThemeData buildWebTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        surface: Colors.grey.shade200, // Diferențe pentru web
        onSurface: Colors.black87,
        primary: const Color(0xFFFFAFED), // Diferențe pentru web
        secondary: const Color(0xFFD3B6FF),
        tertiary: const Color(0xFFA6E0FF),
        outline: Colors.grey.shade500,
      ),
      
    );
  }

  ThemeData buildAndroidTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        surface: Colors.grey.shade100, 
        onSurface: Colors.black,
        primary: const Color(0xFF00B2E7),
        secondary: const Color(0xFFE064F7),
        tertiary: const Color(0xFFFF8D6C),
        outline: Colors.grey.shade400,
      ),
     
    );
  }

}
