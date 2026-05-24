// rental_history_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import to access BookingManager

class RentalHistoryScreen extends StatefulWidget {
  @override
  _RentalHistoryScreenState createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends State<RentalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for booking changes
    BookingManager().addListener(_updateBookings);
  }

  @override
  void dispose() {
    BookingManager().removeListener(_updateBookings);
    super.dispose();
  }

  void _updateBookings() {
    setState(() {});
  }

  // Helper function to format date
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Helper function to format time
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Calculate duration between pickup and dropoff
  String _calculateDuration(DateTime pickupDate, DateTime dropoffDate) {
    final difference = dropoffDate.difference(pickupDate).inDays;
    if (difference == 0) {
      return '1 day';
    } else if (difference == 1) {
      return '1 day';
    } else {
      return '${difference + 1} days';
    }
  }

  // Calculate total cost
  String _calculateCost(String carPrice, DateTime pickupDate, DateTime dropoffDate) {
    // Extract price from string like "Rs 200000/day"
    final priceString = carPrice.replaceAll('Rs ', '').replaceAll('/day', '').replaceAll(',', '');
    final pricePerDay = int.tryParse(priceString) ?? 0;

    final days = dropoffDate.difference(pickupDate).inDays + 1;
    final totalCost = pricePerDay * days;

    return 'Rs ${totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final bookings = BookingManager().bookings;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Changed to match Edit Profile
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rental History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: bookings.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No rental history yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your booking history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(24),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildRentalCard(booking);
        },
      ),
    );
  }

  Widget _buildRentalCard(Booking booking) {
    final duration = _calculateDuration(booking.pickupDate, booking.dropoffDate);
    final cost = _calculateCost(booking.carPrice, booking.pickupDate, booking.dropoffDate);

    return Card(
      elevation: 2,
      color: Colors.white, // Explicitly white
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with car name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Name
                      Text(
                        booking.carName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Booking Date
                      Text(
                        'Booked: ${_formatDate(booking.bookingDate)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: _getStatusTextColor(booking.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Pickup and Dropoff Details
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50], // Light grey background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!), // Added border
              ),
              child: Column(
                children: [
                  // Pickup
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF0066FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Color(0xFF0066FF),
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pickup',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              booking.pickupLocation,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${_formatDate(booking.pickupDate)} at ${_formatTime(booking.pickupTime)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Arrow Divider
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Icon(Icons.arrow_downward, size: 16, color: Colors.grey[400]),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Dropoff
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dropoff',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              booking.dropoffLocation,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${_formatDate(booking.dropoffDate)} at ${_formatTime(booking.dropoffTime)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Divider
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: 16),

            // Footer with duration and cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 6),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.payments,
                      size: 16,
                      color: Color(0xFF0066FF),
                    ),
                    SizedBox(width: 4),
                    Text(
                      cost,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12),

            // Customer Info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF0066FF).withOpacity(0.05), // Changed to match app theme
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF0066FF).withOpacity(0.2)), // Changed border
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 16, color: Color(0xFF0066FF)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.customerName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          booking.customerPhone,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Color(0xFFD1FAE5);
      case 'completed':
        return Color(0xFFDCFCE7);
      case 'cancelled':
        return Color(0xFFFEE2E2);
      case 'pending':
        return Color(0xFFFEF3C7);
      default:
        return Color(0xFFE5E7EB);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Color(0xFF059669);
      case 'completed':
        return Color(0xFF16A34A);
      case 'cancelled':
        return Color(0xFFDC2626);
      case 'pending':
        return Color(0xFFD97706);
      default:
        return Color(0xFF6B7280);
    }
  }
}