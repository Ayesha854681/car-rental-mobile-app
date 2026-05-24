import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const Color primaryBlue = Color(0xFF0066FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Eligibility',
              'You must be at least 18 years old and possess a valid driving license. International renters must provide a valid international driving permit along with their passport.',
            ),
            _buildSection(
              '2. Vehicle Usage',
              'The rented vehicle must be used responsibly and only for legal purposes. The vehicle may not be used for commercial purposes, racing, or any illegal activities. Smoking is strictly prohibited in all vehicles.',
            ),
            _buildSection(
              '3. Payment',
              'All rental charges must be paid in advance. Additional charges may apply for late returns. We accept all major credit cards, debit cards, and digital payment methods. A security deposit may be required and will be refunded after the vehicle is returned in good condition.',
            ),
            _buildSection(
              '4. Damage & Liability',
              'The renter is responsible for any damage during the rental period. You are liable for all damages, theft, or loss of the vehicle during the rental period. We strongly recommend purchasing our comprehensive insurance coverage.',
            ),
            _buildSection(
              '5. Insurance Coverage',
              'Basic insurance is included with all rentals. Additional coverage options are available at checkout. The renter is responsible for any damages not covered by insurance, including but not limited to interior damage, windshield damage, and tire damage.',
            ),
            _buildSection(
              '6. Fuel Policy',
              'All vehicles are provided with a full tank of fuel and must be returned with a full tank. Failure to refill the tank will result in additional charges at a premium rate plus a service fee.',
            ),
            _buildSection(
              '7. Mileage',
              'Each rental includes unlimited mileage within Pakistan. Additional charges apply for cross-border travel. The odometer reading will be recorded at pickup and return.',
            ),
            _buildSection(
              '8. Cancellation',
              'Cancellations must be made at least 24 hours before pickup time for a full refund. Cancellations made within 24 hours of pickup time will incur a 50% cancellation fee. No-shows will be charged the full rental amount.',
            ),
            _buildSection(
              '9. Late Returns',
              'A grace period of 1 hour is provided for returns. Beyond this, late fees will apply at an hourly rate. If the vehicle is returned more than 4 hours late, a full additional day charge will apply.',
            ),
            _buildSection(
              '10. Traffic Violations',
              'The renter is responsible for all traffic violations, parking tickets, and toll charges incurred during the rental period. All fines and penalties will be charged to the credit card on file plus an administrative fee.',
            ),
            _buildSection(
              '11. Vehicle Condition',
              'The vehicle will be inspected before and after rental. Any existing damage will be documented at pickup. The renter must report any damage or mechanical issues immediately. Failure to report damage may result in additional charges.',
            ),
            _buildSection(
              '12. Privacy',
              'Your personal information will be kept confidential and used only for booking purposes. We comply with all data protection regulations and will never share your information with third parties without your consent.',
            ),
            _buildSection(
              '13. Prohibited Activities',
              'The following activities are strictly prohibited: subletting or lending the vehicle to others, using the vehicle while under the influence of alcohol or drugs, transporting illegal goods, and using the vehicle for driving instruction.',
            ),
            _buildSection(
              '14. Breakdown and Accidents',
              'In case of breakdown or accident, contact our 24/7 emergency support immediately. Do not attempt repairs yourself. Exchange insurance information with other parties involved in accidents and file a police report if required by law.',
            ),
            _buildSection(
              '15. Additional Drivers',
              'Additional drivers must be registered at the time of booking and must meet the same eligibility requirements. Additional driver fees apply. Unauthorized drivers will void insurance coverage.',
            ),
            _buildSection(
              '16. Modifications to Terms',
              'Flexi Ride reserves the right to modify these terms and conditions at any time. Continued use of our services constitutes acceptance of any modifications.',
            ),
            _buildSection(
              '17. Agreement',
              'By renting a vehicle from Flexi Ride, you acknowledge that you have read, understood, and agree to all the above terms and conditions. This agreement is legally binding.',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: primaryBlue, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For questions or concerns about these terms, please contact our customer support.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}