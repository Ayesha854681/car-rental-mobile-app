import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController carController;
  late Animation<Offset> carSlide;
  late Animation<double> carScale;
  late Animation<double> carOpacity;

  late AnimationController contentController;
  late Animation<double> contentFade;
  late Animation<Offset> contentSlide;

  @override
  void initState() {
    super.initState();

    // Car animation controller (comes from behind/bottom)
    carController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Car slides from bottom-center upward
    carSlide = Tween<Offset>(
      begin: const Offset(0, 1.5), // Start from bottom (off-screen)
      end: const Offset(0, -0.15),  // End slightly above center
    ).animate(CurvedAnimation(
      parent: carController,
      curve: Curves.easeOut,
    ));

    // Car scale animation (small to normal - perspective effect)
    carScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: carController,
        curve: Curves.easeOut,
      ),
    );

    // Car opacity (fade in as it approaches)
    carOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: carController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Content animation controller
    contentController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Content fade in
    contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: contentController,
        curve: Curves.easeIn,
      ),
    );

    // Content slide from bottom
    contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: contentController,
      curve: Curves.easeOut,
    ));

    // Start car animation immediately
    carController.forward();

    // Start content animation after car settles
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        contentController.forward();
      }
    });

    // Removed auto-navigation - now only navigates when user clicks buttons
  }

  @override
  void dispose() {
    carController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive sizing based on screen dimensions
    final isSmallScreen = height < 700;
    final isMediumScreen = height >= 700 && height < 900;

    // Responsive values
    final carWidth = width * (isSmallScreen ? 0.55 : 0.65);
    final topCircleSize = width * 0.8;
    final horizontalPadding = width * 0.085; // ~32px on standard screens
    final verticalPadding = isSmallScreen ? 32.0 : (isMediumScreen ? 40.0 : 48.0);

    final brandNameSize = isSmallScreen ? 26.0 : (isMediumScreen ? 29.0 : 32.0);
    final titleSize = isSmallScreen ? 18.0 : (isMediumScreen ? 19.0 : 20.0);
    final descriptionSize = isSmallScreen ? 12.0 : 13.0;
    final buttonTextSize = isSmallScreen ? 15.0 : 16.0;
    final bottomTextSize = isSmallScreen ? 13.0 : 14.0;

    final brandTitleSpacing = isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
    final titleDescSpacing = isSmallScreen ? 8.0 : 10.0;
    final descButtonSpacing = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final buttonHeight = isSmallScreen ? 50.0 : 54.0;
    final buttonBottomSpacing = isSmallScreen ? 12.0 : 16.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Decorative curved background element (top)
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: topCircleSize,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Animated Car (comes from behind/bottom)
            Positioned.fill(
              child: SlideTransition(
                position: carSlide,
                child: ScaleTransition(
                  scale: carScale,
                  child: FadeTransition(
                    opacity: carOpacity,
                    child: Center(
                      child: Image.asset(
                        'assets/car.png',
                        width: carWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content section (title, description, button)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: contentSlide,
                child: FadeTransition(
                  opacity: contentFade,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Flexi Ride Brand Name
                        Text(
                          'Flexi Ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: brandNameSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0066FF),
                            letterSpacing: 1.2,
                          ),
                        ),

                        SizedBox(height: brandTitleSpacing),

                        // Title
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            children: const [
                              TextSpan(text: 'Your Ultimate '),
                              TextSpan(
                                text: 'Car Rental\n',
                                style: TextStyle(
                                  color: Color(0xFF0066FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: 'Experience'),
                            ],
                          ),
                        ),

                        SizedBox(height: titleDescSpacing),

                        // Description
                        Text(
                          'Rent. Drive. Explore!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: descriptionSize,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: descButtonSpacing),

                        // Get Started Button - Navigate to Login
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRoutes.login);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Let's Get Started",
                              style: TextStyle(
                                fontSize: buttonTextSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: buttonBottomSpacing),

                        // Sign In text - Navigate to Sign Up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: bottomTextSize,
                                color: Colors.grey[600],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, AppRoutes.signup);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: bottomTextSize,
                                  color: const Color(0xFF0066FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}