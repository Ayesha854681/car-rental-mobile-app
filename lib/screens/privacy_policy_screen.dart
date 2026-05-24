// privacy_policy_screen.dart
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
          'Privacy Policy',
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
              'Information We Collect',
              'We collect information you provide directly to us, including your name, email address, phone number, driver\'s license information, payment information, and location data when you use our car rental services.',
            ),

            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our car rental services, process rental transactions, verify driver eligibility, send you technical notices and support messages, and communicate with you about vehicles, services, and promotional offers.',
            ),

            _buildSection(
              'Location Information',
              'We collect precise location data from your device when the app is running to help you find nearby rental locations, track vehicle pickup and return locations, and provide navigation assistance during your rental period.',
            ),

            _buildSection(
              'Driver\'s License Verification',
              'We collect and verify your driver\'s license information to ensure you meet the legal requirements for renting a vehicle. This information is securely stored and used solely for verification purposes.',
            ),

            _buildSection(
              'Information Sharing',
              'We may share your information with vehicle owners or fleet managers to facilitate rental services, with service providers who perform services on our behalf, with insurance providers when applicable, and when required by law or to protect our rights.',
            ),

            _buildSection(
              'Data Security',
              'We take reasonable measures to help protect your personal information from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction. All payment information is encrypted and processed through secure gateways.',
            ),

            _buildSection(
              'Data Retention',
              'We retain your personal information for as long as necessary to provide our services, comply with legal obligations, resolve disputes, enforce our agreements, and maintain rental history records as required by law.',
            ),

            _buildSection(
              'Your Rights',
              'You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us directly. You may also request copies of your rental history and transaction records.',
            ),

            _buildSection(
              'Cookies and Tracking',
              'We use cookies and similar tracking technologies to track activity on our service, remember your preferences, and hold certain information to improve and analyze our service.',
            ),

            _buildSection(
              'Children\'s Privacy',
              'Our service is not intended for individuals under 18 years of age. We do not knowingly collect personal information from anyone under 18. To rent a vehicle, you must meet the minimum age requirements set by law.',
            ),

            _buildSection(
              'Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page and sending you a notification through the app.',
            ),

            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@flexiride.com or through our customer support channels.',
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