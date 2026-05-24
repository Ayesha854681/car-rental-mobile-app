import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/app_routes.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/car_list_screen.dart';
import 'screens/car_details_screen.dart';
import 'screens/car_data_provider.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // 🔥 WEB Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBtmzm7zK77iryH-aJ5Smp11_r6d7u5bUA",
        authDomain: "flexirideproject.firebaseapp.com",
        projectId: "flexirideproject",
        storageBucket: "flexirideproject.firebasestorage.app",
        messagingSenderId: "791584167770",
        appId: "1:791584167770:web:01f105a07c024748fac563",
        measurementId: "G-146YXDC8ZN",
      ),
    );
  } else {
    // 🔥 Windows / Android Firebase
    await Firebase.initializeApp();
  }

  runApp(FlexiRideApp());
}

class FlexiRideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexi Ride',
      debugShowCheckedModeBanner: false,
      theme: appTheme,

      initialRoute: AppRoutes.splash,

      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.signup: (context) => SignUpScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.admin: (context) => const AdminScreen(),
      },

      // Handle routes with arguments
      onGenerateRoute: (settings) {
        // Handle car list route with category name
        if (settings.name == AppRoutes.carList) {
          final categoryName = settings.arguments as String? ?? 'All Cars';
          return MaterialPageRoute(
            builder: (context) => CarListScreen(categoryName: categoryName),
          );
        }

        // Handle car details route with car object
        if (settings.name == AppRoutes.carDetails) {
          final car = settings.arguments as Car?;
          if (car != null) {
            return MaterialPageRoute(
              builder: (context) => CarDetailsScreen(car: car),
            );
          }
        }

        return null;
      },
    );
  }
}