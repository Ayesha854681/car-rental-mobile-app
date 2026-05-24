import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'terms_conditions_screen.dart';
import 'home_screen.dart'; // Import to access BookingManager
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CarRentalFormScreen extends StatefulWidget {
  final String? carName;
  final String? carImage;
  final String? carPrice;

  const CarRentalFormScreen({
    Key? key,
    this.carName,
    this.carImage,
    this.carPrice,
  }) : super(key: key);

  @override
  State<CarRentalFormScreen> createState() => _CarRentalFormScreenState();
}

class _CarRentalFormScreenState extends State<CarRentalFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _prefixController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSubmitting = false;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  final _licenseController = TextEditingController();
  bool _agreeToTerms = false;

  // Dropdown values
  String? _pickupLocation;
  String? _dropoffLocation;

  // Date and Time values
  DateTime _pickupDate = DateTime.now();
  TimeOfDay _pickupTime = TimeOfDay.now();
  DateTime _dropoffDate = DateTime.now();
  TimeOfDay _dropoffTime = TimeOfDay.now();

  // Birth date
  String? _birthMonth;
  String? _birthDay;
  String? _birthYear;

  final List<String> _locations = [
    'Islamabad Airport',
    'Rawalpindi City',
    'Bahria Town',
    'DHA Islamabad',
    'F-7 Islamabad',
    'Blue Area',
  ];

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Custom colors - matching the hero section blue
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color lightBlue = Color(0xFFE8F1FF);
  static const Color darkBlue = Color(0xFF003D99);
  static const Color cardAccent = Color(0xFF4D94FF);

  @override
  void dispose() {
    _prefixController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickup ? _pickupDate : _dropoffDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
        } else {
          _dropoffDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Future<void> _selectTime(BuildContext context, bool isPickup) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isPickup ? _pickupTime : _dropoffTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = picked;
        } else {
          _dropoffTime = picked;
        }
      });
    }
  }

  // REPLACE the _submitForm() method in car_rental_form_screen.dart
// This is around line 156 in your car_rental_form_screen.dart
  Future<void> _submitForm() async {
    // Check if user is logged in
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to make a booking'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushNamed(context, '/login');
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String customerName = '';
      if (_prefixController.text.isNotEmpty) {
        customerName = '${_prefixController.text} ';
      }
      customerName += '${_firstNameController.text} ${_lastNameController.text}';

      print('📝 Saving booking to Firebase...');
      print('User ID: ${user.uid}');

      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .add({
        'carName': widget.carName ?? 'Unknown Car',
        'carPrice': widget.carPrice ?? 'N/A',
        'carImage': widget.carImage ?? '',
        'pickupLocation': _pickupLocation ?? '',
        'dropoffLocation': _dropoffLocation ?? '',
        'pickupDate': Timestamp.fromDate(_pickupDate),
        'pickupTime': '${_pickupTime.hour.toString().padLeft(2, '0')}:${_pickupTime.minute.toString().padLeft(2, '0')}',
        'dropoffDate': Timestamp.fromDate(_dropoffDate),
        'dropoffTime': '${_dropoffTime.hour.toString().padLeft(2, '0')}:${_dropoffTime.minute.toString().padLeft(2, '0')}',
        'customerName': customerName.trim(),
        'customerEmail': _emailController.text.trim(),
        'customerPhone': _phoneController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'license': _licenseController.text.trim(),
        'birthDate': '$_birthMonth $_birthDay, $_birthYear',
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Booking saved! ID: ${docRef.id}');

      final newBooking = Booking(
        id: docRef.id,
        carName: widget.carName ?? 'Unknown Car',
        carImage: widget.carImage ?? '',
        carPrice: widget.carPrice ?? 'N/A',
        pickupLocation: _pickupLocation ?? '',
        dropoffLocation: _dropoffLocation ?? '',
        pickupDate: _pickupDate,
        pickupTime: _pickupTime,
        dropoffDate: _dropoffDate,
        dropoffTime: _dropoffTime,
        customerName: customerName.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        bookingDate: DateTime.now(),
        status: 'Pending',
      );

      BookingManager().addBooking(newBooking);
      setState(() => _isSubmitting = false);

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF0066FF),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Booking Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your car rental booking has been submitted successfully!',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking ID: ${docRef.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Car: ${widget.carName}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainNavigator(initialIndex: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0066FF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'View Booking',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      print('❌ Error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  InputDecoration _getInputDecoration({String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          widget.carName ?? 'Car Rental Booking',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Info Card (if car details passed)
                if (widget.carName != null) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          if (widget.carImage != null)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primaryBlue.withOpacity(0.15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.carImage!,
                                  width: 100,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 100,
                                        height: 70,
                                        color: lightBlue,
                                        child: Icon(Icons.directions_car, color: primaryBlue, size: 32),
                                      ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.carName!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[900],
                                  ),
                                ),
                                if (widget.carPrice != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.carPrice!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: primaryBlue,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                // Rental Details Section
                _buildSectionTitle('Rental Details', Icons.directions_car),
                const SizedBox(height: 20),

                // Pick-up Location
                _buildLabel('Pick-up Location', required: true),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _pickupLocation,
                  decoration: _getInputDecoration(
                    hintText: 'Select pickup location',
                    suffixIcon: Icon(Icons.location_on, color: primaryBlue),
                  ),
                  validator: (value) => value == null ? 'Please select pick-up location' : null,
                  items: _locations.map((location) {
                    return DropdownMenuItem(value: location, child: Text(location));
                  }).toList(),
                  onChanged: (value) => setState(() => _pickupLocation = value),
                ),
                const SizedBox(height: 20),

                // Pick-up Date and Time
                _buildLabel('Pick-up Date & Time', required: true),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(_pickupDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.calendar_today, color: primaryBlue, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _pickupTime.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.access_time, color: primaryBlue, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Drop-off Location
                _buildLabel('Drop-off Location', required: true),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _dropoffLocation,
                  decoration: _getInputDecoration(
                    hintText: 'Select drop-off location',
                    suffixIcon: Icon(Icons.location_on, color: primaryBlue),
                  ),
                  validator: (value) => value == null ? 'Please select drop-off location' : null,
                  items: _locations.map((location) {
                    return DropdownMenuItem(value: location, child: Text(location));
                  }).toList(),
                  onChanged: (value) => setState(() => _dropoffLocation = value),
                ),
                const SizedBox(height: 20),

                // Drop-off Date and Time
                _buildLabel('Drop-off Date & Time', required: true),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(_dropoffDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.calendar_today, color: primaryBlue, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _dropoffTime.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.access_time, color: primaryBlue, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Personal Information Section
                _buildSectionTitle('Personal Information', Icons.person),
                const SizedBox(height: 20),

                // Full Name
                _buildLabel('Full Name', required: true),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _prefixController,
                        decoration: _getInputDecoration(hintText: 'Mr/Mrs'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: _getInputDecoration(hintText: 'First Name'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: _getInputDecoration(hintText: 'Last Name'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // E-mail
                _buildLabel('E-mail', required: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _getInputDecoration(
                    hintText: 'example@email.com',
                    suffixIcon: Icon(Icons.email_outlined, color: primaryBlue),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone Number
                _buildLabel('Phone Number', required: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _getInputDecoration(
                    hintText: '+92 300 1234567',
                    suffixIcon: Icon(Icons.phone_outlined, color: primaryBlue),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Phone number is required' : null,
                ),
                const SizedBox(height: 20),

                // CNIC Number
                _buildLabel('CNIC Number', required: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _cnicController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                    _CnicInputFormatter(),
                  ],
                  decoration: _getInputDecoration(
                    hintText: '00000-0000000-0',
                    suffixIcon: Icon(Icons.credit_card, color: primaryBlue),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'CNIC is required';
                    if (value!.replaceAll('-', '').length != 13) {
                      return 'Enter valid 13-digit CNIC';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // License Number
                _buildLabel('License Number', required: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _licenseController,
                  decoration: _getInputDecoration(
                    hintText: 'Enter driving license number',
                    suffixIcon: Icon(Icons.badge_outlined, color: primaryBlue),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'License number is required' : null,
                ),
                const SizedBox(height: 20),

                // Birth Date
                _buildLabel('Birth Date', required: true),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _birthMonth,
                        decoration: _getInputDecoration(hintText: 'Month'),
                        validator: (value) => value == null ? 'Required' : null,
                        items: _months.map((month) {
                          return DropdownMenuItem(value: month, child: Text(month));
                        }).toList(),
                        onChanged: (value) => setState(() => _birthMonth = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _birthDay,
                        decoration: _getInputDecoration(hintText: 'Day'),
                        validator: (value) => value == null ? 'Required' : null,
                        items: List.generate(31, (index) => (index + 1).toString())
                            .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                            .toList(),
                        onChanged: (value) => setState(() => _birthDay = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _birthYear,
                        decoration: _getInputDecoration(hintText: 'Year'),
                        validator: (value) => value == null ? 'Required' : null,
                        items: List.generate(80, (index) => (DateTime.now().year - 18 - index).toString())
                            .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                            .toList(),
                        onChanged: (value) => setState(() => _birthYear = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      activeColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          children: [
                            const Text(
                              'I agree with ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TermsConditionsScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Submit Booking',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
        children: required
            ? [
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ]
            : [],
      ),
    );
  }
}

// Custom formatter for CNIC (00000-0000000-0)
class _CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 5 || i == 12) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}