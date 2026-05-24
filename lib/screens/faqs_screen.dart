// faqs_screen.dart
import 'package:flutter/material.dart';

class FAQsScreen extends StatelessWidget {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I rent a car?',
      'answer': 'Open the app, browse available vehicles, select your preferred car, choose your rental dates and times, and confirm your booking. You\'ll receive confirmation details and pickup instructions.'
    },
    {
      'question': 'What documents do I need to rent a car?',
      'answer': 'You need a valid driver\'s license, a government-issued ID (passport or national ID card), and a valid payment method. International renters may need an International Driving Permit.'
    },
    {
      'question': 'Can I cancel or modify my reservation?',
      'answer': 'Yes, you can cancel or modify your reservation through the app. Cancellation charges may apply depending on how far in advance you cancel. Free cancellation is available up to 24 hours before pickup.'
    },
    {
      'question': 'What is included in the rental price?',
      'answer': 'The rental price includes the vehicle for the specified duration, basic insurance coverage, and 24/7 roadside assistance. Additional services like GPS, child seats, or extra insurance can be added for an additional fee.'
    },
    {
      'question': 'What happens if the car breaks down?',
      'answer': 'Contact our 24/7 customer support immediately through the app. We provide roadside assistance and will arrange for a replacement vehicle if needed at no additional cost.'
    },
    {
      'question': 'Can I extend my rental period?',
      'answer': 'Yes, you can request to extend your rental through the app, subject to vehicle availability. Additional charges will apply based on the extended duration.'
    },
    {
      'question': 'What is your fuel policy?',
      'answer': 'Vehicles are provided with a full tank of fuel. You can choose to return the vehicle with a full tank, or pay for fuel at the end of the rental period based on usage.'
    },
    {
      'question': 'Is insurance included in the rental?',
      'answer': 'Basic insurance coverage is included in all rentals. You can upgrade to comprehensive coverage for additional protection against damages, theft, and third-party liability.'
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept credit cards, debit cards, and digital wallets. A security deposit is required at the time of booking and will be refunded after the vehicle is returned in good condition.'
    },
    {
      'question': 'Can someone else drive the rental car?',
      'answer': 'Additional drivers can be added to your rental agreement for a small fee. All drivers must meet the minimum age requirements and provide valid documentation.'
    },
  ];

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
          'FAQs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          return _buildFAQItem(_faqs[index]);
        },
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            faq['question']!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          children: [
            Text(
              faq['answer']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}