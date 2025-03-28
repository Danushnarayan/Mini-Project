import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'pages/intro_page.dart';
import 'pages/home_page.dart';
import 'pages/route.dart';
import 'pages/live_tracking.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REC Transport',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
      initialRoute: '/splash',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const IntroPage());
      case '/login':
        final String role = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (context) => LoginPage(selectedRole: role));
      case '/register':
        final String role = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (context) => RegisterPage(selectedRole: role));
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/routes':
        return MaterialPageRoute(builder: (context) => RoutePage());
      case '/live_tracking':
        return MaterialPageRoute(builder: (context) => LiveTrackingPage());
      case '/splash': 
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      default:
        return MaterialPageRoute(builder: (context) => const IntroPage());
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        opacity = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      checkAuthState();
    });
  }

  void checkAuthState() async {
    // Check if user is already logged in
    final currentUser = _firebaseService.currentUser;
    
    if (!mounted) return;

    if (currentUser != null) {
      // User is logged in, redirect to home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not logged in, redirect to intro page
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_bus, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text("Welcome to REC Transport", 
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple
                )
              ),
              const SizedBox(height: 10),
              const CircularProgressIndicator(color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
