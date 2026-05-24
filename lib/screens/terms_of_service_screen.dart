// terms_of_service_screen.dart
import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
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
          'Terms of Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: December 21, 2024',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 24),

            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using FlexiRide, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),

            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily use FlexiRide for personal, non-commercial car rental purposes. This is the grant of a license, not a transfer of title.',
            ),

            _buildSection(
              '3. User Account',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),

            _buildSection(
              '4. Rental and Cancellation',
              'All rentals are subject to vehicle availability. Cancellation policies apply and may result in charges. You agree to provide accurate pickup and drop-off information for the rented vehicle.',
            ),

            _buildSection(
              '5. Payment Terms',
              'You agree to pay all charges incurred under your account including rental fees, insurance, and any additional services. Prices are subject to change. Payment is processed through secure payment gateways.',
            ),

            _buildSection(
              '6. User Conduct',
              'You agree not to misuse the service, damage rental vehicles, or engage in any illegal activities while using our platform. Vehicles must be returned in the same condition as received.',
            ),

            _buildSection(
              '7. Vehicle Responsibility',
              'You are responsible for the rented vehicle during the rental period. Any damages, theft, or violations will be your responsibility unless covered by insurance purchased through our platform.',
            ),

            _buildSection(
              '8. Limitation of Liability',
              'FlexiRide shall not be liable for any indirect, incidental, special, consequential or punitive damages resulting from your use of the service or rental vehicles.',
            ),

            _buildSection(
              '9. Modifications',
              'We reserve the right to modify these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms.',
            ),

            _buildSection(
              '10. Contact Information',
              'For any questions about these Terms, please contact us at support@flexiride.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}