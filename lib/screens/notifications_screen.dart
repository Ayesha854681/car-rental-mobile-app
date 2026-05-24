// notifications_screen.dart
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, bool> _notifications = {
    'bookingUpdates': true,
    'promotions': false,
    'newFeatures': true,
    'emailNotifications': true,
    'smsNotifications': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),

            // Push Notifications Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Push Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildToggleItem(
                    title: 'Booking Updates',
                    subtitle: 'Get notified about your bookings',
                    value: _notifications['bookingUpdates']!,
                    onChanged: (value) {
                      setState(() {
                        _notifications['bookingUpdates'] = value;
                      });
                    },
                  ),
                  Divider(height: 32, color: Colors.grey[300]),
                  _buildToggleItem(
                    title: 'Promotions & Offers',
                    subtitle: 'Receive special deals and discounts',
                    value: _notifications['promotions']!,
                    onChanged: (value) {
                      setState(() {
                        _notifications['promotions'] = value;
                      });
                    },
                  ),
                  Divider(height: 32, color: Colors.grey[300]),
                  _buildToggleItem(
                    title: 'New Features',
                    subtitle: 'Learn about new app features',
                    value: _notifications['newFeatures']!,
                    onChanged: (value) {
                      setState(() {
                        _notifications['newFeatures'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Other Channels Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Other Channels',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildToggleItem(
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: _notifications['emailNotifications']!,
                    onChanged: (value) {
                      setState(() {
                        _notifications['emailNotifications'] = value;
                      });
                    },
                  ),
                  Divider(height: 32, color: Colors.grey[300]),
                  _buildToggleItem(
                    title: 'SMS Notifications',
                    subtitle: 'Get text message alerts',
                    value: _notifications['smsNotifications']!,
                    onChanged: (value) {
                      setState(() {
                        _notifications['smsNotifications'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF2563EB),
        ),
      ],
    );
  }
}