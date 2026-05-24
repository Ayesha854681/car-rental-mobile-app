import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'car_data_provider.dart';
import 'car_details_screen.dart';
import 'car_rental_form_screen.dart';
import 'home_screen.dart';  // This imports FavoritesManager
import 'firebase_car_service.dart';  // ADD THIS LINE

/// CAR LIST SCREEN
/// Shows all cars in a specific category with modern card layout
class CarListScreen extends StatefulWidget {
  final String categoryName;

  const CarListScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}
class _CarListScreenState extends State<CarListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseCarService _carService = FirebaseCarService();  // NEW

  List<Car> cars = [];
  bool isLoading = true;   // NEW
  String? errorMessage;    // NEW

  @override
  void initState() {
    super.initState();
    _loadCarsFromFirebase();  // CHANGED
  }

  // NEW METHOD - Load cars from Firebase
  Future<void> _loadCarsFromFirebase() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      List<Car> fetchedCars = await _carService.getCarsByCategory(widget.categoryName);

      setState(() {
        cars = fetchedCars;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load cars: $e';
        isLoading = false;
      });
      print('Error loading cars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0066FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF0066FF),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [  // NEW - Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF0066FF)),
            onPressed: _loadCarsFromFirebase,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),  // CHANGED
    );
  }

  // NEW METHOD - Build body with loading states
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF0066FF),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCarsFromFirebase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (cars.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No cars available in this category',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth > 600;
        int crossAxisCount = isLargeScreen ? 2 : 1;

        return GridView.builder(
          padding: EdgeInsets.all(isLargeScreen ? 20 : 14),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: isLargeScreen ? 1.15 : 1.05,
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            return _buildCarCard(cars[index], isLargeScreen);
          },
        );
      },
    );
  }

  Widget _buildCarCard(Car car, bool isLargeScreen) {
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[50],
                      child: CachedNetworkImage(
                        imageUrl: car.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0066FF),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          print('Failed to load: $url');
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.directions_car,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                        memCacheWidth: 800,
                        memCacheHeight: 600,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: buildStatusBadge(car.status),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          FavoritesManager().toggleFavorite(car);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          FavoritesManager().isFavorite(car)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: FavoritesManager().isFavorite(car)
                              ? Colors.red
                              : Colors.grey[700],
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Text(
                        car.location,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        '${car.rating}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.settings, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          car.transmission,
                          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.event_seat, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Text(
                        '${car.seats}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs ${car.pricePerDay.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Text(
                          '/day',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    child:ElevatedButton(
                      onPressed: car.status.toLowerCase() == 'available'
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarRentalFormScreen(
                              carName: car.name,
                              carImage: car.imageUrl,
                              carPrice: 'Rs ${car.pricePerDay.toStringAsFixed(0)}/day',
                            ),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: car.status.toLowerCase() == 'available'
                            ? const Color(0xFF0066FF)
                            : Colors.grey[400],
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        car.status.toLowerCase() == 'available' ? 'RENT NOW' : 'UNAVAILABLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
