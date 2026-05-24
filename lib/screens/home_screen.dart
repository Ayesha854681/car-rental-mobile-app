import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'car_list_screen.dart';
import 'car_data_provider.dart';
import 'car_rental_form_screen.dart';
import 'car_details_screen.dart';
import 'rental_history_screen.dart';
import 'notifications_screen.dart';
import 'payment_methods_screen.dart';
import'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'dart:ui';
import 'booking_page.dart';
import '../utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_car_service.dart';
// ✅ ADD THIS FUNCTION AT THE TOP OF home_screen.dart
Widget buildStatusBadge(String status) {
  Color statusColor;
  String statusText;

  switch (status.toLowerCase()) {
    case 'available':
      statusColor = Colors.green;
      statusText = 'Available';
      break;
    case 'booked':
      statusColor = Colors.orange;
      statusText = 'Booked';
      break;
    case 'maintenance':
      statusColor = Colors.red;
      statusText = 'Maintenance';
      break;
    default:
      statusColor = Colors.green;
      statusText = 'Available';
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: statusColor,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          color: statusColor.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      statusText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
class ResponsiveHelper {
  // Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Check if mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < 600;
  }

  // Make font sizes smaller on small screens
  static double fontSize(BuildContext context, double size) {
    double width = screenWidth(context);
    if (width < 360) return size * 0.85; // Very small phones
    if (width < 400) return size * 0.9;  // Medium phones
    return size; // Normal size for larger screens
  }

  // Make padding smaller on small screens
  static double padding(BuildContext context, double size) {
    double width = screenWidth(context);
    if (width < 360) return size * 0.8;
    return size;
  }
}


void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flexi Ride',
      theme: ThemeData(
        primaryColor: const Color(0xFF0066FF),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Arial',
      ),
      home: const MainNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Favorites Manager - Singleton
class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<Car> _favorites = [];
  final List<VoidCallback> _listeners = [];

  List<Car> get favorites => List.unmodifiable(_favorites);

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  bool isFavorite(Car car) {
    return _favorites.any((c) => c.name == car.name);
  }

  void toggleFavorite(Car car) {
    if (isFavorite(car)) {
      _favorites.removeWhere((c) => c.name == car.name);
    } else {
      _favorites.add(car);
    }
    _notifyListeners();
  }
}
// Add this class RIGHT AFTER the FavoritesManager class in home_screen.dart
// (around line 50, after FavoritesManager closing brace)

class BookingManager {
  static final BookingManager _instance = BookingManager._internal();
  factory BookingManager() => _instance;
  BookingManager._internal();

  final List<Booking> _bookings = [];
  final List<VoidCallback> _listeners = [];

  List<Booking> get bookings => List.unmodifiable(_bookings);

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void addBooking(Booking booking) {
    _bookings.insert(0, booking); // Add to beginning for newest first
    _notifyListeners();
  }

  void removeBooking(String bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    _notifyListeners();
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: newStatus);
      _notifyListeners();
    }
  }
}

// Booking Model Class
// FIXED Booking Model Class
// Replace the existing Booking class in home_screen.dart with this:

class Booking {
  final String id;
  final String carName;
  final String carImage;
  final String carPrice;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupDate;
  final TimeOfDay pickupTime;
  final DateTime dropoffDate;
  final TimeOfDay dropoffTime;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.carName,
    required this.carImage,
    required this.carPrice,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.dropoffDate,
    required this.dropoffTime,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.bookingDate,
    this.status = 'Confirmed',
  });

  Booking copyWith({String? status}) {
    return Booking(
      id: id,
      carName: carName,
      carImage: carImage,
      carPrice: carPrice,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      pickupDate: pickupDate,
      pickupTime: pickupTime,
      dropoffDate: dropoffDate,
      dropoffTime: dropoffTime,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      bookingDate: bookingDate,
      status: status ?? this.status,
    );
  }}
class CarAvailabilityService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // OPTIMIZED: Get all available cars for a category in ONE query
  static Future<List<Car>> getAvailableCarsForCategory({
    required String category,
    required DateTime pickupDate,
    required DateTime returnDate,
  }) async {
    try {
      List<Car> categoryCars = _getCarsForCategory(category);

      // If no cars in category, return empty list immediately
      if (categoryCars.isEmpty) {
        return [];
      }

      // Get ALL bookings with status Confirmed or Active in ONE query
      QuerySnapshot bookings = await _firestore
          .collection('bookings')
          .where('status', whereIn: ['Confirmed', 'Active'])
          .get();

      // Create a Set of booked car names for the requested date range
      Set<String> bookedCarNames = {};

      for (var doc in bookings.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          String carName = data['carName'] ?? '';

          // Skip if no pickup/dropoff dates
          if (!data.containsKey('pickupDate') || !data.containsKey('dropoffDate')) {
            continue;
          }

          DateTime existingPickup = (data['pickupDate'] as Timestamp).toDate();
          DateTime existingReturn = (data['dropoffDate'] as Timestamp).toDate();

          // Check for date overlap
          bool hasOverlap = !(returnDate.isBefore(existingPickup) ||
              pickupDate.isAfter(existingReturn));

          if (hasOverlap) {
            bookedCarNames.add(carName);
          }
        } catch (e) {
          print('Error processing booking document: $e');
          continue;
        }
      }

      // Filter out booked cars
      List<Car> availableCars = categoryCars
          .where((car) => !bookedCarNames.contains(car.name))
          .toList();

      return availableCars;

    } catch (e) {
      print('Error checking availability: $e');
      // If there's an error, return all cars in category (fail-safe)
      return _getCarsForCategory(category);
    }
  }

  static List<Car> _getCarsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'luxury sedans':
        return CarDataProvider.getLuxurySedans();
      case 'opulence cars':
        return CarDataProvider.getOpulenceCars();
      case 'suvs':
        return CarDataProvider.getSUVs();
      case 'convertibles':
        return CarDataProvider.getConvertibles();
      case 'electric cars':
        return CarDataProvider.getElectricCars();
      case 'minivans':
        return CarDataProvider.getMinivans();
      case 'hatchbacks':
        return CarDataProvider.getHatchbacks();
      case 'crossovers':
        return CarDataProvider.getCrossovers();
      default:
        return [];
    }
  }
}
// User Profile Manager - Singleton
class UserProfileManager {
  static final UserProfileManager _instance = UserProfileManager._internal();
  factory UserProfileManager() => _instance;
  UserProfileManager._internal();

  String _name = 'Guest User';
  String _email = 'guest@flexiride.com';
  String _phone = '+92 300 1234567';
  final List<VoidCallback> _listeners = [];

  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _notifyListeners();
  }

  // NEW METHOD: Load user data from Firebase
  Future<void> loadUserDataFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Get user email from Firebase Auth
        _email = currentUser.email ?? 'guest@flexiride.com';

        // Get display name from Firebase Auth (if available)
        _name = currentUser.displayName ?? 'User';

        // If you're storing additional data in Firestore, fetch it:
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          _name = userData['name'] ?? _name;
          _email = userData['email'] ?? _email;
          _phone = userData['phone'] ?? _phone;
        }

        _notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // NEW METHOD: Clear user data on logout
  void clearUserData() {
    _name = 'Guest User';
    _email = 'guest@flexiride.com';
    _phone = '+92 300 1234567';
    _notifyListeners();
  }
}
// Main Navigator with Bottom Navigation
// REPLACE the MainNavigator class in home_screen.dart
// This starts around line 170 in your home_screen.dart

class MainNavigator extends StatefulWidget {
  final int initialIndex; // ADD THIS LINE

  const MainNavigator({
    Key? key,
    this.initialIndex = 0, // ADD THIS LINE - defaults to 0 (Home)
  }) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}
class _MainNavigatorState extends State<MainNavigator> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const FavoritesPage(),
    const BookingPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // NEW: Load user data from Firebase when app starts
    _loadUserData();
  }

  // NEW METHOD: Load user data
  Future<void> _loadUserData() async {
    await UserProfileManager().loadUserDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    // ... rest of your build method stays the same
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.favorite, 'Favorites'),
                _buildNavItem(2, Icons.book_online, 'Booking'),
                _buildNavItem(3, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    bool isMobile = ResponsiveHelper.isMobile(context); // ✅ Check if mobile

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20, // ✅ Smaller padding on mobile
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0066FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: isMobile ? 20 : 24, // ✅ Smaller icons on mobile
            ),
            if (isSelected && !isMobile) ...[ // ✅ Hide label on mobile
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.fontSize(context, 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
// Place this OUTSIDE the _HomePageState class, after it closes
class _HoverCategoryCard extends StatefulWidget {
  final Map<String, String> category;

  const _HoverCategoryCard({required this.category});

  @override
  State<_HoverCategoryCard> createState() => _HoverCategoryCardState();
}
class _HoverPopularVehicleCard extends StatefulWidget {
  final Car car;
  final String category;

  const _HoverPopularVehicleCard({
    required this.car,
    required this.category,
  });

  @override
  State<_HoverPopularVehicleCard> createState() => _HoverPopularVehicleCardState();
}

class _HoverPopularVehicleCardState extends State<_HoverPopularVehicleCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovering ? -8.0 : 0.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailsScreen(car: widget.car),
              ),
            );
          },
          child: Container(
            width: 240,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovering ? 0.15 : 0.08),
                  blurRadius: _isHovering ? 20 : 10,
                  offset: Offset(0, _isHovering ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(  // ✅ NEW
                    imageUrl: widget.car.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    placeholder: (context, url) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0066FF),
                          strokeWidth: 2,
                        ),
                      ),
                    ),

                    errorWidget: (context, url, error) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.car_rental, size: 50),
                    ),

                    memCacheWidth: 600,
                    memCacheHeight: 400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.car.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Rs ${widget.car.pricePerDay.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/day',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            widget.car.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.car.rating} (${widget.car.totalTrips} trips)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _HoverCategoryCardState extends State<_HoverCategoryCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovering ? -8.0 : 0.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarListScreen(categoryName: widget.category['route']!),
              ),
            );
          },
          child: Card(
            elevation: _isHovering ? 12 : 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF2b0000)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.network(
                      widget.category['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.car_rental, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.category['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            widget.category['description']!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF777777),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'CLICK NOW!',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedLocation = 'All';
  String _selectedPriceRange = 'All Prices';
  bool _showFilteredResults = false;
  String _selectedTransmission = 'All';
  String _selectedSeats = 'All';

  final List<Map<String, String>> categories = [
    {
      'name': 'Luxury Sedans',
      'image': 'https://images.prismic.io/carwow/Z1CM8JbqstJ98CZJ_2024AudiA5Saloonfrontquarterdriving2.jpg?auto=format&cs=tinysrgb&fit=max&q=60',
      'description': 'Affordable and efficient cars for everyday use.',
      'route': 'luxury sedans'
    },
    {
      'name': 'Opulence Cars',
      'image': 'https://hips.hearstapps.com/hmg-prod/images/2020-bentley-flying-spur-608-hdr-1594131894.jpg?crop=0.737xw:0.553xh;0,0.430xh&resize=1800:*',
      'description': 'Experience comfort and style with our premium vehicles.',
      'route': 'opulence cars'
    },
    {
      'name': 'SUVs',
      'image': 'https://hips.hearstapps.com/hmg-prod/images/2025-genesis-gv80-149-6642229d26dcf.jpg?crop=0.748xw:0.632xh;0.172xw,0.163xh&resize=700:*',
      'description': 'Perfect for families and off-road adventures.',
      'route': 'suvs'
    },
    {
      'name': 'Convertibles',
      'image': 'https://hips.hearstapps.com/hmg-prod/amv-prod-cad-assets/wp-content/uploads/2016/08/2016-Volkswagen-Beetle-convertible-Denim-Edition-122.jpg',
      'description': 'Enjoy the open road with a sporty convertible.',
      'route': 'convertibles'
    },
    {
      'name': 'Electric Cars',
      'image': 'https://hips.hearstapps.com/hmg-prod/images/2019-audi-e-tron-1545086914.jpg?crop=0.904xw:0.830xh;0.0497xw,0.170xh&resize=2048:*',
      'description': 'Drive green with our selection of electric cars.',
      'route': 'electric cars'
    },
    {
      'name': 'Minivans',
      'image': 'https://hips.hearstapps.com/hmg-prod/images/2025-kia-carnival-pr-123-679407094c63f.jpg?crop=1xw:1xh;center,top',
      'description': 'Perfect for group travel and family trips.',
      'route': 'minivans'
    },
    {
      'name': 'Hatchbacks',
      'image': 'https://images.pistonheads.com/nimg/48939/blobid0.jpg',
      'description': 'Perfect for small and tight city areas.',
      'route': 'hatchbacks'
    },
    {
      'name': 'Crossovers',
      'image': 'https://hips.hearstapps.com/hmg-prod/images/2024-bmw-x5-m60i-102-6602d48787fb7.jpg?crop=1xw:1xh;center,top',
      'description': 'Perfect for group travel and family trips.',
      'route': 'crossovers'
    },
  ];

  // Popular Vehicles Data - Using actual cars from CarDataProvider with real data
  List<Map<String, dynamic>> getPopularVehicles() {
    return [
      {
        'car': CarDataProvider.getOpulenceCars()[0], // Rolls-Royce Wraith
        'category': 'opulence cars'
      },
      {
        'car': CarDataProvider.getSUVs()[0], // BMW X7
        'category': 'suvs'
      },
      {
        'car': CarDataProvider.getElectricCars()[0], // BMW i4
        'category': 'electric cars'
      },
      {
        'car': CarDataProvider.getConvertibles()[3],
        // Mini Cooper S Convertible
        'category': 'convertibles'
      },
      {
        'car': CarDataProvider.getCrossovers()[1], // Porsche Macan Turbo
        'category': 'crossovers'
      },
      {
        'car': CarDataProvider.getLuxurySedans()[3], // Civic Rs 2024
        'category': 'luxury sedans'
      },
    ];
  }

  String getCategoryForCar(Car car) {
    if (CarDataProvider.getOpulenceCars().any((c) => c.name == car.name)) {
      return 'Opulence';
    } else if (CarDataProvider.getSUVs().any((c) => c.name == car.name)) {
      return 'SUV';
    } else
    if (CarDataProvider.getElectricCars().any((c) => c.name == car.name)) {
      return 'Electric';
    } else
    if (CarDataProvider.getConvertibles().any((c) => c.name == car.name)) {
      return 'Convertible';
    } else if (CarDataProvider.getCrossovers().any((c) => c.name == car.name)) {
      return 'Crossover';
    } else
    if (CarDataProvider.getLuxurySedans().any((c) => c.name == car.name)) {
      return 'Luxury Sedan';
    } else if (CarDataProvider.getMinivans().any((c) => c.name == car.name)) {
      return 'Minivan';
    } else if (CarDataProvider.getHatchbacks().any((c) => c.name == car.name)) {
      return 'Hatchback';
    }
    return 'Sedan';
  }

  List<Car> getAllCars() {
    return [
      ...CarDataProvider.getLuxurySedans(),
      ...CarDataProvider.getOpulenceCars(),
      ...CarDataProvider.getSUVs(),
      ...CarDataProvider.getConvertibles(),
      ...CarDataProvider.getElectricCars(),
      ...CarDataProvider.getMinivans(),
      ...CarDataProvider.getHatchbacks(),
      ...CarDataProvider.getCrossovers(),
    ];
  }
  List<String> getAllLocations() {
    final allCars = getAllCars();
    final locations = allCars.map((car) => car.location).toSet().toList();
    locations.sort();
    locations.insert(0, 'All'); // Add "All" option at the beginning
    return locations;
  }


  bool matchesPriceRange(Car car, String selectedRange) {
    double price = car.pricePerDay;

    switch (selectedRange) {
      case '20,000 – 40,000':
        return price >= 20000 && price <= 40000;

      case '40,000 – 70,000':
        return price >= 40000 && price <= 70000;

      case '70,000 – 120,000':
        return price >= 70000 && price <= 120000;

      case '120,000 – 200,000':
        return price >= 120000 && price <= 200000;

      case '200,000 – 350,000':
        return price >= 200000 && price <= 350000;

      case '350,000 – 500,000':
        return price >= 350000 && price <= 500000;

      case '500,000+':
        return price >= 500000;

      default:
        return true; // All Prices
    }
  }

  List<Car> getFilteredCars() {
    final allCars = CarDataProvider.getAllCars();

    return allCars.where((car) {
      final priceMatch = matchesPriceRange(car, _selectedPriceRange);

      final transmissionMatch =
          _selectedTransmission == 'All' ||
              car.transmission.toLowerCase().contains(
                _selectedTransmission.toLowerCase(),
              );

      final seatsMatch =
          _selectedSeats == 'All' ||
              (_selectedSeats == '7+' && car.seats >= 7) ||
              car.seats.toString() == _selectedSeats;

      return priceMatch && transmissionMatch && seatsMatch;
    }).toList();
  }

  void _navigateToCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarListScreen(categoryName: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildHeroSection(),
            _buildPopularVehiclesSection(),
            _buildFeaturesSection(),
            const SizedBox(height: 20),
            _buildFiltersSection(),
//     const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(context, 16), // ✅ Responsive padding
            vertical: ResponsiveHelper.padding(context, 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Menu + Logo
              Expanded( // ✅ Prevents overflow
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.menu,
                          color: Color(0xFF0066FF),
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible( // ✅ Makes logo flexible
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible( // ✅ Text can shrink
                            child: Text(
                              'Flexi Ride',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 20), // ✅ Responsive font
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0066FF),
                                letterSpacing: -0.5,
                              ),
                              overflow: TextOverflow.ellipsis, // ✅ Prevents overflow
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right side - Hide on small screens
              if (ResponsiveHelper.screenWidth(context) > 500) // ✅ Only show on bigger screens
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeaderButton('Cars', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllCarsListScreen(),
                          ),
                        );
                      }),
                      _buildHeaderButton('About', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      }),
                      _buildHeaderButton('Contact', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          height: ResponsiveHelper.isMobile(context) ? 450 : 500, // ✅ Shorter on mobile
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1580654712603-eb43273aff33?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Ymx1ZSUyMGNhcnxlbnwwfHwwfHx8MA%3D%3D',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0066FF).withOpacity(0.4),
                  const Color(0xFF0066FF).withOpacity(0.2),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: SingleChildScrollView( // ✅ Allows scrolling on tiny screens
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(context, 20), // ✅ Responsive padding
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Discover Your Perfect Drive',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 28), // ✅ Responsive font (was 48)
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Premium vehicles for every occasion. Seamless booking, unforgettable journeys.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: ResponsiveHelper.fontSize(context, 14), // ✅ Responsive font (was 18)
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildSearchCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSearchCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.isMobile(context) ? double.infinity : 750,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(context, 16),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.padding(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Find Cars by Location',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 18),
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.padding(context, 20)),

          // Location Selection Dropdown
          _buildLocationDropdown(),

          SizedBox(height: ResponsiveHelper.padding(context, 20)),

          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066FF).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _searchCarsByLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Search Available Cars',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Location',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedLocation,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_city, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            hint: Text('Choose a location'),
            items: getAllLocations().map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLocation = newValue ?? 'All';
              });
            },
          ),
        ),
      ],
    );
  }


// METHOD 2: Search Available Cars
  void _searchCarsByLocation() {
    if (_selectedLocation == 'All') {
      // Show all cars
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationBasedCarsScreen(
            location: 'All Locations',
            cars: getAllCars(),
          ),
        ),
      );
    } else {
      // Filter cars by selected location
      List<Car> carsInLocation = getAllCars()
          .where((car) => car.location == _selectedLocation)
          .toList();

      if (carsInLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No cars available in $_selectedLocation'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationBasedCarsScreen(
              location: _selectedLocation,
              cars: carsInLocation,
            ),
          ),
        );
      }
    }
  }

  // EXACT POPULAR VEHICLES SECTION FROM YOUR OLD CODE
  Widget _buildPopularVehiclesSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Vehicles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'The perfect car for your trip',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300, // Increased from 280 to 290
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Added top padding
            scrollDirection: Axis.horizontal,
            itemCount: getPopularVehicles().length,
            itemBuilder: (context, index) {
              return _buildPopularVehicleCard(getPopularVehicles()[index]);
            },
          ),
        ),
        const SizedBox(height: 3),
      ],
    );
  }


  Widget _buildPopularVehicleCard(Map<String, dynamic> vehicleData) {
    final Car car = vehicleData['car'];
    final String category = vehicleData['category'];

    return _HoverPopularVehicleCard(car: car, category: category);
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      color: const Color(0xFFF5F5F5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 768;
          if (isWide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildFeatureItem(
                    Icons.verified_user, 'Fully Insured', 'Complete coverage',
                    [Color(0xFF10B981), Color(0xFF059669)])), // Green
                const SizedBox(width: 20),
                Expanded(child: _buildFeatureItem(
                    Icons.check_circle, 'Best Price', 'Guaranteed',
                    [Color(0xFFF59E0B), Color(0xFFD97706)])), // Orange
                const SizedBox(width: 20),
                Expanded(child: _buildFeatureItem(
                    Icons.calendar_month, 'Flexible', 'No hidden fees',
                    [Color(0xFF8B5CF6), Color(0xFF7C3AED)])), // Purple
                const SizedBox(width: 20),
                Expanded(child: _buildFeatureItem(
                    Icons.support_agent, '24/7 Support', 'Always here',
                    [Color(0xFFEC4899), Color(0xFFDB2777)])), // Pink
              ],
            );
          } else {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureItem(
                    Icons.verified_user, 'Fully Insured', 'Complete coverage',
                    [Color(0xFF10B981), Color(0xFF059669)]),
                _buildFeatureItem(
                    Icons.check_circle, 'Best Price', 'Guaranteed',
                    [Color(0xFFF59E0B), Color(0xFFD97706)]),
                _buildFeatureItem(
                    Icons.calendar_month, 'Flexible', 'No hidden fees',
                    [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
                _buildFeatureItem(
                    Icons.support_agent, '24/7 Support', 'Always here',
                    [Color(0xFFEC4899), Color(0xFFDB2777)]),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle,
      List<Color> gradientColors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String> category) {
    return _HoverCategoryCard(category: category);
  }

  Widget _buildFiltersSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 900;

        if (isWideScreen) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFiltersPanel(),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show categories header and grid when NOT showing filtered results
                      if (!_showFilteredResults) ...[
                        _buildAvailableCarsHeader(),
                        const SizedBox(height: 20),
                        _buildAvailableCarsGrid(),
                      ],
                      // Show filtered results when filter is applied
                      if (_showFilteredResults) _buildFilteredResultsSection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              // Show categories header and grid when NOT showing filtered results
              if (!_showFilteredResults) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildAvailableCarsHeader(),
                ),
                const SizedBox(height: 20),
                _buildAvailableCarsGrid(),
              ],
              // Show filtered results when filter is applied
              if (_showFilteredResults) _buildFilteredResultsSection(),
            ],
          );
        }
      },
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.tune, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilterSection(
            'Price Range',
            [
              'All Prices',
              '20,000 – 40,000',
              '40,000 – 70,000',
              '70,000 – 120,000',
              '120,000 – 200,000',
              '200,000 – 350,000',
              '350,000 – 500,000',
              '500,000+',
            ],
            _selectedPriceRange,
                (value) => setState(() => _selectedPriceRange = value),
          ),
          const SizedBox(height: 20),
          _buildFilterSection('Transmission', ['All', 'Automatic', 'Manual'],
              _selectedTransmission, (value) =>
                  setState(() => _selectedTransmission = value)),
          const SizedBox(height: 20),
          _buildFilterSection('Seats', ['All', '2', '4', '5', '7+'],
              _selectedSeats, (value) =>
                  setState(() => _selectedSeats = value)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  setState(() {
                    _showFilteredResults = true;
                  }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Set Filter',
                style: TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                setState(() {
                  _selectedPriceRange = 'All Prices';
                  _selectedTransmission = 'All';
                  _selectedSeats = 'All';
                  _showFilteredResults = false;
                }),
            child: const Text('Reset Filter'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      String selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...options.map((option) {
          bool isSelected = selectedValue == option;
          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0066FF).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons
                        .radio_button_unchecked,
                    color: isSelected ? const Color(0xFF0066FF) : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(option, style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF0066FF) : Colors
                        .black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight
                        .normal,
                  )),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAvailableCarsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Available Car Categories',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'Choose a category to explore vehicles',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
  Widget _buildAvailableCarsGrid() {
    final List<Map<String, String>> displayCategories = categories.take(8).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(context, 20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          double width = constraints.maxWidth;

          // ✅ NEW: 2 columns per row logic
          if (width < 400) {
            crossAxisCount = 1; // 1 column on very small phones
          } else {
            crossAxisCount = 2; // 2 columns on ALL other screens (phones, tablets, desktop)
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // ✅ Dynamic columns
              crossAxisSpacing: ResponsiveHelper.padding(context, 16),
              mainAxisSpacing: ResponsiveHelper.padding(context, 16),
              childAspectRatio: 0.95,
            ),
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final category = displayCategories[index];
              return _buildCategoryCard(category);
            },
          );
        },
      ),
    );
  }


  Widget _buildFilteredResultsSection() {
    final filteredCars = getFilteredCars();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtered Results',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${filteredCars.length} cars found',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (filteredCars.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No cars match your filters',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try adjusting your filter criteria',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount =
                constraints.maxWidth > 1200 ? 4 : constraints.maxWidth > 768
                    ? 3
                    : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    return _buildCarCard(filteredCars[index]);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCarCard(Car car) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isFav = FavoritesManager().isFavorite(car);
        String category = getCategoryForCar(car);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailsScreen(car: car),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with category badge and favorite button - INCREASED HEIGHT
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        car.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.car_rental, size: 60),
                        ),
                      ),
                    ),

                    // ✅ ADD STATUS BADGE - TOP LEFT
                    Positioned(
                      top: 8,
                      left: 8,
                      child: buildStatusBadge(car.status),
                    ),

                    // Category Badge - TOP RIGHT (near favorite)
                    Positioned(
                      top: 8,
                      right: 54,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0066FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Favorite Button (keep your existing code)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => FavoritesManager().toggleFavorite(car)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Car Details - COMPACT LAYOUT
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Name
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // First Row: Location and Rating
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              car.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            car.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Second Row: Transmission and Seats
                      Row(
                        children: [
                          Icon(Icons.settings, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              car.transmission,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${car.seats}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Price and Rent Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs ${car.pricePerDay.toInt()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0066FF),
                                ),
                              ),
                              Text(
                                '/day',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // Rent Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarRentalFormScreen(
                                    carName: car.name,
                                    carImage: car.imageUrl,
                                    carPrice: 'Rs ${car.pricePerDay.toInt()}/day',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Rent',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFFF8F9FA),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF0066FF),
                          const Color(0xFF0052CC),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0066FF).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Car Categories',
                    style: TextStyle(
                      color: Color(0xFF0066FF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      _buildDrawerItem('Home Page', 'home', Icons.home),
                      const SizedBox(height: 8),
                      ...categories.map((cat) => _buildDrawerItem(
                        cat['name']!,
                        cat['route']!,
                        _getCategoryIcon(cat['route']!),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF0066FF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String route) {
    switch (route) {
      case 'luxury sedans':
        return Icons.directions_car;
      case 'opulence cars':
        return Icons.stars;
      case 'suvs':
        return Icons.airport_shuttle;
      case 'convertibles':
        return Icons.directions_car_filled;
      case 'electric cars':
        return Icons.electric_car;
      case 'minivans':
        return Icons.airport_shuttle_outlined;
      case 'hatchbacks':
        return Icons.drive_eta;
      case 'crossovers':
        return Icons.car_rental;
      default:
        return Icons.directions_car;
    }
  }

  Widget _buildDrawerItem(String title, String route, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066FF).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: const Color(0xFF0066FF).withOpacity(0.1),
              highlightColor: const Color(0xFF0066FF).withOpacity(0.05),
              onTap: () {
                Navigator.pop(context);
                if (route != 'home') _navigateToCategory(route);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF0066FF),
                            const Color(0xFF0052CC),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0066FF).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF0066FF),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllCarsListScreen extends StatelessWidget {
  const AllCarsListScreen({Key? key}) : super(key: key);

  List<Car> getAllCars() => [
    ...CarDataProvider.getLuxurySedans(),
    ...CarDataProvider.getOpulenceCars(),
    ...CarDataProvider.getSUVs(),
    ...CarDataProvider.getConvertibles(),
    ...CarDataProvider.getElectricCars(),
    ...CarDataProvider.getMinivans(),
    ...CarDataProvider.getHatchbacks(),
    ...CarDataProvider.getCrossovers(),
  ];

  String getCategoryForCar(Car car) {
    if (CarDataProvider.getOpulenceCars().any((c) => c.name == car.name)) return 'Opulence';
    if (CarDataProvider.getSUVs().any((c) => c.name == car.name)) return 'SUV';
    if (CarDataProvider.getElectricCars().any((c) => c.name == car.name)) return 'Electric';
    if (CarDataProvider.getConvertibles().any((c) => c.name == car.name)) return 'Convertible';
    if (CarDataProvider.getCrossovers().any((c) => c.name == car.name)) return 'Crossover';
    if (CarDataProvider.getLuxurySedans().any((c) => c.name == car.name)) return 'Luxury Sedan';
    if (CarDataProvider.getMinivans().any((c) => c.name == car.name)) return 'Minivan';
    if (CarDataProvider.getHatchbacks().any((c) => c.name == car.name)) return 'Hatchback';
    return 'Sedan';
  }

  @override
  Widget build(BuildContext context) {
    List<Car> allCars = getAllCars();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('All Cars', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 1200 ? 4 : constraints.maxWidth > 768 ? 3 : 2;
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.75), // Slightly smaller cards
            itemCount: allCars.length,
            itemBuilder: (context, index) => _buildCarCard(allCars[index], context),
          );
        },
      ),
    );
  }

  Widget _buildCarCard(Car car, BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      bool isFav = FavoritesManager().isFavorite(car);
      String category = getCategoryForCar(car);

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailsScreen(car: car),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with category badge and favorite button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      car.imageUrl,
                      height: 200, // CHANGED from 140 to 200
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200, // CHANGED from 140 to 200
                        color: Colors.grey[300],
                        child: const Icon(Icons.car_rental, size: 60), // CHANGED from 50 to 60
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: buildStatusBadge(car.status),
                  ),

                  // Category Badge - MOVED TO RIGHT (near favorite button)
                  Positioned(
                    top: 8,
                    right: 54, // Make room for favorite button
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF0066FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => FavoritesManager().toggleFavorite(car)),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Car Details
              Padding(
                padding: const EdgeInsets.all(12), // CHANGED from 10 to 12
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car Name
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 16, // CHANGED from 15 to 16
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // First Row: Location and Rating
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]), // CHANGED from 13 to 14
                        const SizedBox(width: 4), // CHANGED from 2 to 4
                        Expanded(
                          child: Text(
                            car.location,
                            style: TextStyle(
                              fontSize: 12, // CHANGED from 11 to 12
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12), // CHANGED from 4 to 12
                        const Icon(Icons.star, size: 14, color: Colors.amber), // CHANGED from 13 to 14
                        const SizedBox(width: 4), // CHANGED from 2 to 4
                        Text(
                          car.rating.toString(),
                          style: TextStyle(
                            fontSize: 12, // CHANGED from 11 to 12
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Second Row: Transmission and Seats
                    Row(
                      children: [
                        Icon(Icons.settings, size: 14, color: Colors.grey[600]), // CHANGED from 13 to 14
                        const SizedBox(width: 4), // CHANGED from 2 to 4
                        Expanded(
                          child: Text(
                            car.transmission,
                            style: TextStyle(
                              fontSize: 12, // CHANGED from 11 to 12
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12), // CHANGED from 4 to 12
                        Icon(Icons.people, size: 14, color: Colors.grey[600]), // CHANGED from 13 to 14
                        const SizedBox(width: 4), // CHANGED from 2 to 4
                        Text(
                          '${car.seats}',
                          style: TextStyle(
                            fontSize: 12, // CHANGED from 11 to 12
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // CHANGED from 8 to 10

                    // Price and Rent Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rs ${car.pricePerDay.toInt()}',
                              style: const TextStyle(
                                fontSize: 18, // CHANGED from 16 to 18
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0066FF),
                              ),
                            ),
                            Text(
                              '/day',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        // Rent Button - NEW
                        ElevatedButton(
                          onPressed: car.status.toLowerCase() == 'available'
                              ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarRentalFormScreen(
                                  carName: car.name,
                                  carImage: car.imageUrl,
                                  carPrice: 'Rs ${car.pricePerDay.toInt()}/day',
                                ),
                              ),
                            );
                          }
                              : null, // ✅ Disabled when not available
                          style: ElevatedButton.styleFrom(
                            backgroundColor: car.status.toLowerCase() == 'available'
                                ? const Color(0xFF0066FF)
                                : Colors.grey[400], // ✅ Grey when disabled
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            car.status.toLowerCase() == 'available' ? 'Rent' : 'Unavailable',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }}
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    FavoritesManager().addListener(_updateFavorites);
  }

  @override
  void dispose() {
    FavoritesManager().removeListener(_updateFavorites);
    super.dispose();
  }

  void _updateFavorites() => setState(() {});

  String getCategoryForCar(Car car) {
    if (CarDataProvider.getOpulenceCars().any((c) => c.name == car.name)) return 'Opulence';
    if (CarDataProvider.getSUVs().any((c) => c.name == car.name)) return 'SUV';
    if (CarDataProvider.getElectricCars().any((c) => c.name == car.name)) return 'Electric';
    if (CarDataProvider.getConvertibles().any((c) => c.name == car.name)) return 'Convertible';
    if (CarDataProvider.getCrossovers().any((c) => c.name == car.name)) return 'Crossover';
    if (CarDataProvider.getLuxurySedans().any((c) => c.name == car.name)) return 'Luxury Sedan';
    if (CarDataProvider.getMinivans().any((c) => c.name == car.name)) return 'Minivan';
    if (CarDataProvider.getHatchbacks().any((c) => c.name == car.name)) return 'Hatchback';
    return 'Sedan';
  }

  @override
  Widget build(BuildContext context) {
    List<Car> favorites = FavoritesManager().favorites;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          title: const Text('Favorites', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true),
      body: favorites.isEmpty ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.favorite_border, size: 100, color: Colors.grey),
        SizedBox(height: 20),
        Text('No favorites yet', style: TextStyle(fontSize: 20, color: Colors.grey)),
        SizedBox(height: 10),
        Text('Start adding cars to your favorites!', style: TextStyle(fontSize: 16, color: Colors.grey)),
      ])) : LayoutBuilder(builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200 ? 4 : constraints.maxWidth > 768 ? 3 : 2;
        return GridView.builder(padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 0.75),
            itemCount: favorites.length,
            itemBuilder: (context, index) => _buildFavoriteCard(favorites[index]));
      }),
    );
  }

  Widget _buildFavoriteCard(Car car) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(car.imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 140, color: Colors.grey[300], child: const Icon(Icons.car_rental, size: 50)))),
          Positioned(top: 8, left: 8, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF0066FF), borderRadius: BorderRadius.circular(6)),
              child: Text(getCategoryForCar(car), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)))),
          Positioned(top: 8, right: 8, child: GestureDetector(
              onTap: () => FavoritesManager().toggleFavorite(car),
              child: Container(padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                  child: const Icon(Icons.favorite, color: Colors.red, size: 20)))),
        ]),
        Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(car.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text('Rs ${car.pricePerDay.toInt()}/day', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0066FF))),
        ])),
      ]),
    );
  }
}




// Replace your existing ProfilePage class with this updated version

// Replace your existing ProfilePage class with this version
// This matches your EXACT original design with working navigation
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Listen for profile updates
    UserProfileManager().addListener(_updateProfile);
  }

  @override
  void dispose() {
    UserProfileManager().removeListener(_updateProfile);
    super.dispose();
  }

  void _updateProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF0066FF),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  UserProfileManager().name, // Dynamic name from UserProfileManager
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  UserProfileManager().email, // Dynamic email from UserProfileManager
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Menu Items
          _buildProfileOption(
            context,
            Icons.person,
            'Edit Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            context,
            Icons.history,
            'Rental History',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RentalHistoryScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            context,
            Icons.payment,
            'Payment Methods',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentMethodsScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            context,
            Icons.notifications,
            'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            context,
            Icons.settings,
            'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            context,
            Icons.help,
            'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpSupportScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            context,
            Icons.logout,
            'Logout',
            isRed: true,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context,
      IconData icon,
      String title, {
        bool isRed = false,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isRed ? Colors.red : const Color(0xFF0066FF),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isRed ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();

                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // Clear user data
                UserProfileManager().clearUserData();

                // Navigate to splash screen and clear all previous routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.splash,
                      (Route route) => false,
                );

                // Show success message
                Future.delayed(Duration(milliseconds: 500), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
class AvailableCarsResultScreen extends StatelessWidget {
  final List<Car> cars;
  final String category;
  final String pickupDate;
  final String returnDate;

  const AvailableCarsResultScreen({
    Key? key,
    required this.cars,
    required this.category,
    required this.pickupDate,
    required this.returnDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Available $category',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFF0066FF).withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF0066FF), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'From $pickupDate to $returnDate',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0066FF),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${cars.length} Available',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1200
                    ? 4
                    : constraints.maxWidth > 768
                    ? 3
                    : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: cars.length,
                  itemBuilder: (context, index) => _buildCarCard(cars[index], context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Car car, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isFav = FavoritesManager().isFavorite(car);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailsScreen(car: car),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: car.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0066FF),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.car_rental, size: 60),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: buildStatusBadge(car.status),
                    ),

                    // Category Badge - MOVED TO RIGHT (near favorite button)
                    Positioned(
                      top: 8,
                      right: 54, // Make room for favorite button
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF0066FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => FavoritesManager().toggleFavorite(car)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              car.location,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            car.rating.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.settings, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              car.transmission,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${car.seats}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs ${car.pricePerDay.toInt()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0066FF),
                                ),
                              ),
                              Text(
                                '/day',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarRentalFormScreen(
                                    carName: car.name,
                                    carImage: car.imageUrl,
                                    carPrice: 'Rs ${car.pricePerDay.toInt()}/day',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Rent',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class LocationBasedCarsScreen extends StatelessWidget {
  final String location;
  final List<Car> cars;

  const LocationBasedCarsScreen({
    Key? key,
    required this.location,
    required this.cars,
  }) : super(key: key);

  String getCategoryForCar(Car car) {
    if (CarDataProvider.getOpulenceCars().any((c) => c.name == car.name)) return 'Opulence';
    if (CarDataProvider.getSUVs().any((c) => c.name == car.name)) return 'SUV';
    if (CarDataProvider.getElectricCars().any((c) => c.name == car.name)) return 'Electric';
    if (CarDataProvider.getConvertibles().any((c) => c.name == car.name)) return 'Convertible';
    if (CarDataProvider.getCrossovers().any((c) => c.name == car.name)) return 'Crossover';
    if (CarDataProvider.getLuxurySedans().any((c) => c.name == car.name)) return 'Luxury Sedan';
    if (CarDataProvider.getMinivans().any((c) => c.name == car.name)) return 'Minivan';
    if (CarDataProvider.getHatchbacks().any((c) => c.name == car.name)) return 'Hatchback';
    return 'Sedan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Cars in $location',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFF0066FF).withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF0066FF), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$location - ${cars.length} cars available',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0066FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1200
                    ? 4
                    : constraints.maxWidth > 768
                    ? 3
                    : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: cars.length,
                  itemBuilder: (context, index) => _buildCarCard(cars[index], context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Car car, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isFav = FavoritesManager().isFavorite(car);
        String category = getCategoryForCar(car);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailsScreen(car: car),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: car.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0066FF),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.car_rental, size: 60),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF0066FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => FavoritesManager().toggleFavorite(car)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              car.location,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            car.rating.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.settings, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              car.transmission,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${car.seats}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs ${car.pricePerDay.toInt()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0066FF),
                                ),
                              ),
                              Text(
                                '/day',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarRentalFormScreen(
                                    carName: car.name,
                                    carImage: car.imageUrl,
                                    carPrice: 'Rs ${car.pricePerDay.toInt()}/day',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Rent',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
