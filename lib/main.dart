import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe/screens/tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: ".env");

  // Check if the user is logged in
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;

  runApp(
    App(isLoggedIn: isLoggedIn),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.isLoggedIn,
  });

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color(0xFF48B04C),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF48B04C),
          unselectedItemColor: Colors.grey,
        ),
      ),
      // Set initial screen based on login state
      home: isLoggedIn ? const TabScreen() : const LoginScreen(),
    );
  }
}
