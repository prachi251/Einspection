import 'package:flutter/material.dart';
import 'screens/auth_portal_screen.dart';
import 'screens/login_screen.dart';
import 'screens/railway_dashboard.dart'; // Import your dashboard screen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Inspection App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPortalScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const RailwayDashboard(),
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'screens/auth_portal_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/railway_dashboard.dart'; // Import your dashboard screen

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'E-Inspection App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         scaffoldBackgroundColor: Colors.white,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const AuthPortalScreen(),
//         '/login': (context) => const LoginScreen(),
//         // Remove /dashboard route here, navigate to it after login
//       },
//     );
//   }
// }

