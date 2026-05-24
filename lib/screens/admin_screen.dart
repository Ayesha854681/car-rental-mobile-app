import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'upload_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TabController _tabController;

  int totalCars = 0;
  int availableCars = 0;
  int bookedCars = 0;
  int totalBookings = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStatistics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    try {
      final carsSnapshot = await _firestore.collection('cars').get();
      totalCars = carsSnapshot.docs.length;

      availableCars = carsSnapshot.docs.where((doc) =>
      (doc.data()['status'] ?? 'available') == 'available'
      ).length;
      bookedCars = carsSnapshot.docs.where((doc) =>
      (doc.data()['status'] ?? 'available') == 'booked'
      ).length;

      final usersSnapshot = await _firestore.collection('users').get();
      int bookingsCount = 0;

      for (var userDoc in usersSnapshot.docs) {
        final bookingsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('bookings')
            .get();
        bookingsCount += bookingsSnapshot.docs.length;
      }

      totalBookings = bookingsCount;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadStatistics,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await _auth.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard(
                  'Total Cars',
                  totalCars.toString(),
                  Icons.directions_car,
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Available',
                  availableCars.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Booked',
                  bookedCars.toString(),
                  Icons.event_busy,
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Total Bookings',
                  totalBookings.toString(),
                  Icons.book_online,
                  Colors.purple,
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0066FF),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF0066FF),
              tabs: const [
                Tab(text: 'Car Management'),
                Tab(text: 'Bookings'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCarManagementTab(),
                _buildBookingsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          // Upload Cars Button (NEW)
          FloatingActionButton.extended(
          onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const UploadScreen()),
    );
    },
      heroTag: 'upload', // Required when using multiple FABs
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.cloud_upload),
      label: const Text('Upload Cars'),
    ),
    const SizedBox(height: 16),
     FloatingActionButton.extended(
        onPressed: _showAddCarDialog,
        backgroundColor: const Color(0xFF0066FF),
        icon: const Icon(Icons.add),
        label: const Text('Add New Car'),
      ),
    ]));
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ADD NEW CAR DIALOG
  void _showAddCarDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final imageUrlController = TextEditingController();
    final priceController = TextEditingController();
    final seatsController = TextEditingController();
    final transmissionController = TextEditingController();
    final averageController = TextEditingController();
    final mileageController = TextEditingController();
    final conditionController = TextEditingController();
    final ratingController = TextEditingController();
    final locationController = TextEditingController();

    String selectedFuelType = 'Petrol';
    String selectedCategory = 'luxury sedans';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Car'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Car Name *',
                        hintText: 'e.g., Porsche Panamera 2021',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL *',
                        hintText: 'https://...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'luxury sedans', child: Text('Luxury Sedans')),
                        DropdownMenuItem(value: 'minivans', child: Text('Minivans')),
                        DropdownMenuItem(value: 'opulence cars', child: Text('Opulence Cars')),
                        DropdownMenuItem(value: 'suvs', child: Text('SUVs')),
                        DropdownMenuItem(value: 'hatchbacks', child: Text('Hatchbacks')),
                        DropdownMenuItem(value: 'convertibles', child: Text('Convertibles')),
                        DropdownMenuItem(value: 'crossovers', child: Text('Crossovers')),
                        DropdownMenuItem(value: 'electric cars', child: Text('Electric')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price Per Day (Rs) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: seatsController,
                            decoration: const InputDecoration(
                              labelText: 'Seats *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedFuelType,
                      decoration: const InputDecoration(
                        labelText: 'Fuel Type *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Petrol', child: Text('Petrol')),
                        DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                        DropdownMenuItem(value: 'Electric', child: Text('Electric')),
                        DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedFuelType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: transmissionController,
                      decoration: const InputDecoration(
                        labelText: 'Transmission *',
                        hintText: 'e.g., 8-speed dual-clutch automatic',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: averageController,
                      decoration: const InputDecoration(
                        labelText: 'Average (km/L) *',
                        hintText: 'e.g., 8-12 km/L',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: mileageController,
                            decoration: const InputDecoration(
                              labelText: 'Mileage (km) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: conditionController,
                            decoration: const InputDecoration(
                              labelText: 'Condition (0-10) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Required';
                              final val = double.tryParse(value!);
                              if (val == null || val < 0 || val > 10) {
                                return '0-10';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ratingController,
                            decoration: const InputDecoration(
                              labelText: 'Rating (0-5) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Required';
                              final val = double.tryParse(value!);
                              if (val == null || val < 0 || val > 5) {
                                return '0-5';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location *',
                              hintText: 'e.g., Islamabad',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  await _addNewCar(
                    name: nameController.text.trim(),
                    imageUrl: imageUrlController.text.trim(),
                    category: selectedCategory,
                    pricePerDay: int.parse(priceController.text.trim()),
                    seats: int.parse(seatsController.text.trim()),
                    fuelType: selectedFuelType,
                    transmission: transmissionController.text.trim(),
                    average: averageController.text.trim(),
                    mileage: int.parse(mileageController.text.trim()),
                    condition: double.parse(conditionController.text.trim()),
                    rating: double.parse(ratingController.text.trim()),
                    location: locationController.text.trim(),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
              ),
              child: const Text('Add Car'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addNewCar({
    required String name,
    required String imageUrl,
    required String category,
    required int pricePerDay,
    required int seats,
    required String fuelType,
    required String transmission,
    required String average,
    required int mileage,
    required double condition,
    required double rating,
    required String location,
  }) async {
    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Create car document in Firestore (ID will be auto-generated)
      final carData = {
        'name': name,
        'imageUrl': imageUrl,
        'category': category,
        'pricePerDay': pricePerDay,
        'seats': seats,
        'fuelType': fuelType,
        'transmission': transmission,
        'average': average,
        'mileage': mileage,
        'condition': condition,
        'rating': rating,
        'totalTrips': 0,
        'location': location,
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add to both main cars collection AND category subcollection
      // Add to main cars collection
      await _firestore.collection('cars').add(carData);

      // Also add to category subcollection (like 'luxury sedans', 'minivans', etc.)
      await _firestore.collection('cars').doc(category).collection(category).add(carData);

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Reload statistics
      await _loadStatistics();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name added successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding car: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // CAR MANAGEMENT TAB
  Widget _buildCarManagementTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('cars').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No cars available',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // Get all cars and remove duplicates
        final cars = snapshot.data!.docs.toSet().toList();

        // Sort cars by category, then by name within each category
        cars.sort((a, b) {
          final carA = a.data() as Map<String, dynamic>;
          final carB = b.data() as Map<String, dynamic>;

          final categoryA = carA['category'] ?? 'unknown';
          final categoryB = carB['category'] ?? 'unknown';

          // First compare by category
          int categoryComparison = categoryA.compareTo(categoryB);
          if (categoryComparison != 0) {
            return categoryComparison;
          }

          // If same category, sort by name
          final nameA = carA['name'] ?? '';
          final nameB = carB['name'] ?? '';
          return nameA.compareTo(nameB);
        });

        // Group cars by category
        Map<String, List<Map<String, dynamic>>> groupedCars = {};
        for (var doc in cars) {
          final car = doc.data() as Map<String, dynamic>;
          final carId = doc.id;
          final category = car['category'] ?? 'Unknown';

          if (!groupedCars.containsKey(category)) {
            groupedCars[category] = [];
          }
          groupedCars[category]!.add({
            'data': car,
            'id': carId,
          });
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedCars.length,
          itemBuilder: (context, categoryIndex) {
            final category = groupedCars.keys.elementAt(categoryIndex);
            final categoryCars = groupedCars[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin:  EdgeInsets.only(bottom: 16, top: categoryIndex > 0 ? 24 : 0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0066FF),
                        const Color(0xFF0052CC),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatCategoryName(category),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${categoryCars.length} cars',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cars Grid (3 per row)
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 1400 ? 4 :
                    constraints.maxWidth > 1000 ? 3 :
                    constraints.maxWidth > 600 ? 2 : 1;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: categoryCars.length,
                      itemBuilder: (context, index) {
                        final carData = categoryCars[index];
                        return _buildCarCard(carData['data'], carData['id']);
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

// Helper method to format category names
  String _formatCategoryName(String category) {
    return category
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

// Helper method to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
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

// ✅ Helper method to count cars in a category
  int _countCarsInCategory(List<QueryDocumentSnapshot> cars, String category) {
    return cars.where((doc) {
      final car = doc.data() as Map<String, dynamic>;
      return (car['category'] ?? 'unknown') == category;
    }).length;
  }

  Widget _buildCarCard(Map<String, dynamic> car, String carId) {
    final status = car['status'] ?? 'available';
    final imageUrl = car['imageUrl'] ?? car['image'] ?? '';
    final price = car['pricePerDay'] ?? car['price'] ?? 0;
    final totalTrips = car['totalTrips'] ?? car['trips'] ?? 0;

    Color statusColor = status == 'available' ? Colors.green :
    status == 'booked' ? Colors.orange : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.directions_car, size: 60, color: Colors.grey),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.directions_car, size: 60, color: Colors.grey),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name'] ?? 'Unknown Car',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs ${price.toString()}/day',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          car['location'] ?? 'N/A',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        '${car['rating'] ?? 5.0}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' ($totalTrips trips)',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: status,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            items: ['available', 'booked', 'maintenance']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value[0].toUpperCase() + value.substring(1)),
                              );
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                _updateCarStatus(carId, newStatus);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red[600], size: 20),
                          onPressed: () => _deleteCar(carId),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCarStatus(String carId, String newStatus) async {
    try {
      await _firestore.collection('cars').doc(carId).update({
        'status': newStatus,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car status updated!')),
        );
        _loadStatistics();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    }
  }

  Future<void> _deleteCar(String carId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car'),
        content: const Text('Are you sure you want to delete this car?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestore.collection('cars').doc(carId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Car deleted successfully!')),
          );
          _loadStatistics();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting car: $e')),
          );
        }
      }
    }
  }

  // BOOKINGS TAB
  Widget _buildBookingsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAllBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0066FF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.book_online,
                    size: 80,
                    color: Color(0xFF0066FF),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No bookings yet',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        final bookings = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _buildBookingCard(booking);
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAllBookings() async {
    try {
      List<Map<String, dynamic>> allBookings = [];

      final usersSnapshot = await _firestore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        final bookingsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .get();

        for (var bookingDoc in bookingsSnapshot.docs) {
          final data = bookingDoc.data();
          allBookings.add({
            'bookingId': bookingDoc.id,
            'userId': userDoc.id,
            ...data,
          });
        }
      }

      allBookings.sort((a, b) {
        final aTime = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        final bTime = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });

      return allBookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      rethrow;
    }
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor;
    IconData statusIcon;

    final status = booking['status'] ?? 'Pending';

    switch (status.toLowerCase()) {
      case 'confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    final isActionable = status.toLowerCase() != 'confirmed' &&
        status.toLowerCase() != 'completed' &&
        status.toLowerCase() != 'cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    booking['carImage'] ?? '',
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.directions_car),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['carName'] ?? 'Unknown Car',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['carPrice'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Color(0xFF0066FF)),
                    const SizedBox(width: 8),
                    Text(
                      booking['customerName'] ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    const Icon(Icons.phone, size: 16, color: Color(0xFF0066FF)),
                    const SizedBox(width: 8),
                    Text(
                      booking['customerPhone'] ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Color(0xFF0066FF)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${booking['pickupLocation'] ?? 'N/A'} → ${booking['dropoffLocation'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showBookingDetails(booking),
                    child: const Text('Details'),
                  ),
                ),
                if (isActionable) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateBookingStatus(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Booking ID: ${booking['bookingId']}'),
              Text('User ID: ${booking['userId']}'),
              const Divider(),
              Text('Car: ${booking['carName']}'),
              Text('Price: ${booking['carPrice']}'),
              const Divider(),
              Text('Customer: ${booking['customerName']}'),
              Text('Email: ${booking['customerEmail']}'),
              Text('Phone: ${booking['customerPhone']}'),
              const Divider(),
              Text('Pickup: ${booking['pickupLocation']}'),
              Text('Dropoff: ${booking['dropoffLocation']}'),
              const Divider(),
              Text('Status: ${booking['status']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateBookingStatus(Map<String, dynamic> booking) async {
    try {
      await _firestore
          .collection('users')
          .doc(booking['userId'])
          .collection('bookings')
          .doc(booking['bookingId'])
          .update({'status': 'Confirmed'});

      final carId = booking['carId'];

      if (carId != null && carId.toString().isNotEmpty) {
        await _firestore.collection('cars').doc(carId.toString()).update({
          'status': 'booked',
        });
      }

      await _loadStatistics();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed and car marked as booked!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}