import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momento/screens/welcome_screen.dart';
import 'package:momento/screens/home_screen.dart';
import 'package:momento/screens/login_screen.dart';
import 'package:momento/screens/signup_screen.dart';

void main() {
  runApp(MomentoApp());
}

class MomentoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1CA7EC), // Bright Blue
        scaffoldBackgroundColor: Color(0xFF7BD5F5), // Light Blue
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF1CA7EC), // Bright Blue
          secondary: Color(0xFF4ADEDE), // Turquoise
          tertiary: Color(0xFF787FF6), // Medium Blue
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2F98), // Dark Blue
            fontSize: 20,
          ),
          bodyLarge: GoogleFonts.poppins(
            color: Color(0xFF1F2F98).withOpacity(0.7),
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: Color(0xFF1F2F98).withOpacity(0.5),
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              color: Color(0xFF1F2F98), // Dark Blue text for primary buttons
            ),
          ),
        ),
      ),
      initialRoute:
          '/', // TODO: Add logic to skip welcome for returning users (e.g., using shared preferences)
      routes: {
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}
