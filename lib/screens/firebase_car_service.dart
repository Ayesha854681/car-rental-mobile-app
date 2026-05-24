import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_data_provider.dart';

class FirebaseCarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String carsCollection = 'cars';

  static final FirebaseCarService _instance = FirebaseCarService._internal();
  factory FirebaseCarService() => _instance;
  FirebaseCarService._internal();

  // ✅ UPDATED: Upload with status field
  Future<void> uploadAllCarsToFirebase() async {
    try {
      print('🚀 Starting upload...');

      List<Car> allCars = CarDataProvider.getAllCars();

      for (var car in allCars) {
        await _firestore.collection(carsCollection).add({
          'name': car.name,
          'imageUrl': car.imageUrl,
          'pricePerDay': car.pricePerDay,
          'seats': car.seats,
          'fuelType': car.fuelType,
          'transmission': car.transmission,
          'average': car.average,
          'mileage': car.mileage,
          'condition': car.condition,
          'rating': car.rating,
          'totalTrips': car.totalTrips,
          'location': car.location,
          'category': _getCategoryForCar(car),
          'status': car.status,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('✅ Uploaded: ${car.name}');
      }

      print('🎉 Upload complete!');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  String _getCategoryForCar(Car car) {
    if (CarDataProvider.getLuxurySedans().any((c) => c.name == car.name)) return 'luxury sedans';
    if (CarDataProvider.getMinivans().any((c) => c.name == car.name)) return 'minivans';
    if (CarDataProvider.getOpulenceCars().any((c) => c.name == car.name)) return 'opulence cars';
    if (CarDataProvider.getHatchbacks().any((c) => c.name == car.name)) return 'hatchbacks';
    if (CarDataProvider.getElectricCars().any((c) => c.name == car.name)) return 'electric cars';
    if (CarDataProvider.getCrossovers().any((c) => c.name == car.name)) return 'crossovers';
    if (CarDataProvider.getConvertibles().any((c) => c.name == car.name)) return 'convertibles';
    if (CarDataProvider.getSUVs().any((c) => c.name == car.name)) return 'suvs';
    return 'unknown';
  }

  // ✅ UPDATED: Get cars by category with status
  Future<List<Car>> getCarsByCategory(String categoryName) async {
    try {
      String category = _normalizeCategoryName(categoryName);

      QuerySnapshot snapshot = await _firestore
          .collection(carsCollection)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) => _carFromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error fetching cars by category: $e');
      return [];
    }
  }

  // ✅ UPDATED: Get all cars with status
  Future<List<Car>> getAllCars() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(carsCollection).get();
      return snapshot.docs.map((doc) => _carFromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error fetching all cars: $e');
      return [];
    }
  }

  // ✅ NEW METHOD: Get real-time stream of cars (for live updates)
  Stream<List<Car>> getCarsStream() {
    return _firestore.collection(carsCollection).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => _carFromFirestore(doc)).toList(),
    );
  }

  // ✅ NEW METHOD: Get real-time stream by category
  Stream<List<Car>> getCarsByCategoryStream(String categoryName) {
    String category = _normalizeCategoryName(categoryName);
    return _firestore
        .collection(carsCollection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => _carFromFirestore(doc)).toList(),
    );
  }

  // ✅ UPDATED: Convert Firestore document to Car object WITH ALL FIELDS
  Car _carFromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Car(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      pricePerDay: (data['pricePerDay'] ?? 0).toDouble(),
      seats: data['seats'] ?? 0,
      fuelType: data['fuelType'] ?? '',
      transmission: data['transmission'] ?? '',
      average: data['average'] ?? '',
      mileage: data['mileage'] ?? 0,
      condition: (data['condition'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      totalTrips: data['totalTrips'] ?? 0,
      location: data['location'] ?? '',
      status: data['status'] ?? 'Available', // ✅ Default to Available
    );
  }

  // ✅ NEW METHOD: Update car status by car name
  Future<void> updateCarStatus(String carName, String newStatus) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(carsCollection)
          .where('name', isEqualTo: carName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;
        await _firestore.collection(carsCollection).doc(docId).update({
          'status': newStatus,
        });
        print('✅ Status updated for $carName to $newStatus');
      } else {
        print('❌ Car not found: $carName');
      }
    } catch (e) {
      print('❌ Error updating car status: $e');
      rethrow;
    }
  }

  // ✅ NEW METHOD: Update car status by document ID (used by admin)
  Future<void> updateCarStatusById(String docId, String newStatus) async {
    try {
      await _firestore.collection(carsCollection).doc(docId).update({
        'status': newStatus,
      });
      print('✅ Status updated to $newStatus');
    } catch (e) {
      print('❌ Error updating status: $e');
      rethrow;
    }
  }

  // ✅ NEW METHOD: Get car by name
  Future<Car?> getCarByName(String carName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(carsCollection)
          .where('name', isEqualTo: carName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return _carFromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      print('❌ Error fetching car: $e');
      return null;
    }
  }

  // ✅ NEW STATIC METHOD: Fetch all cars with Firebase status
  static Future<List<Car>> getAllCarsWithStatus() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get all cars from static data
      List<Car> allCars = CarDataProvider.getAllCars();

      // Fetch all cars from Firebase in one query
      QuerySnapshot snapshot = await firestore.collection('cars').get();

      // Create a map of car names to Firebase status
      Map<String, String> carStatusMap = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String carName = data['name'] ?? '';
        String status = data['status'] ?? 'Available';
        carStatusMap[carName] = status;
      }

      // Update each car with Firebase status
      List<Car> updatedCars = allCars.map((car) {
        String firebaseStatus = carStatusMap[car.name] ?? car.status;

        return Car(
          name: car.name,
          imageUrl: car.imageUrl,
          pricePerDay: car.pricePerDay,
          rating: car.rating,
          totalTrips: car.totalTrips,
          location: car.location,
          fuelType: car.fuelType,
          transmission: car.transmission,
          seats: car.seats,
          average: car.average,
          mileage: car.mileage,
          condition: car.condition,
          status: firebaseStatus, // Use Firebase status
        );
      }).toList();

      return updatedCars;
    } catch (e) {
      print('Error fetching cars with status: $e');
      return CarDataProvider.getAllCars(); // Fallback to static data
    }
  }

  // ✅ NEW STATIC METHOD: Fetch cars by category with Firebase status
  static Future<List<Car>> getCarsByCategoryWithStatus(String category) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      List<Car> categoryCars;

      switch (category.toLowerCase()) {
        case 'luxury sedans':
          categoryCars = CarDataProvider.getLuxurySedans();
          break;
        case 'opulence cars':
          categoryCars = CarDataProvider.getOpulenceCars();
          break;
        case 'suvs':
          categoryCars = CarDataProvider.getSUVs();
          break;
        case 'convertibles':
          categoryCars = CarDataProvider.getConvertibles();
          break;
        case 'electric cars':
          categoryCars = CarDataProvider.getElectricCars();
          break;
        case 'minivans':
          categoryCars = CarDataProvider.getMinivans();
          break;
        case 'hatchbacks':
          categoryCars = CarDataProvider.getHatchbacks();
          break;
        case 'crossovers':
          categoryCars = CarDataProvider.getCrossovers();
          break;
        default:
          return [];
      }

      // Fetch all cars from Firebase
      QuerySnapshot snapshot = await firestore.collection('cars').get();

      // Create a map of car names to Firebase status
      Map<String, String> carStatusMap = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String carName = data['name'] ?? '';
        String status = data['status'] ?? 'Available';
        carStatusMap[carName] = status;
      }

      // Update each car with Firebase status
      List<Car> updatedCars = categoryCars.map((car) {
        String firebaseStatus = carStatusMap[car.name] ?? car.status;

        return Car(
          name: car.name,
          imageUrl: car.imageUrl,
          pricePerDay: car.pricePerDay,
          rating: car.rating,
          totalTrips: car.totalTrips,
          location: car.location,
          fuelType: car.fuelType,
          transmission: car.transmission,
          seats: car.seats,
          average: car.average,
          mileage: car.mileage,
          condition: car.condition,
          status: firebaseStatus,
        );
      }).toList();

      return updatedCars;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // ✅ NEW STATIC METHOD: Get cars by location with Firebase status
  static Future<List<Car>> getCarsByLocationWithStatus(String location) async {
    try {
      List<Car> allCars = await getAllCarsWithStatus();

      if (location == 'All' || location.isEmpty) {
        return allCars;
      }

      return allCars.where((car) => car.location == location).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  String _normalizeCategoryName(String categoryName) {
    String normalized = categoryName.toLowerCase().trim();

    Map<String, String> categoryMap = {
      'luxury sedans': 'luxury sedans',
      'minivans': 'minivans',
      'opulence cars': 'opulence cars',
      'hatchbacks': 'hatchbacks',
      'electric cars': 'electric cars',
      'crossovers': 'crossovers',
      'convertibles': 'convertibles',
      'suvs': 'suvs',
    };

    return categoryMap[normalized] ?? normalized;
  }
}