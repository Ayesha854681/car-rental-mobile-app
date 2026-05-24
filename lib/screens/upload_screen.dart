import 'package:flutter/material.dart';
import 'firebase_car_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isUploading = false;
  bool uploadComplete = false;
  String message = 'Ready to upload 48 cars';

  Future<void> _uploadCars() async {
    setState(() {
      isUploading = true;
      message = 'Uploading cars...';
    });

    try {
      await FirebaseCarService().uploadAllCarsToFirebase();

      setState(() {
        isUploading = false;
        uploadComplete = true;
        message = '✅ Upload Complete!';
      });
    } catch (e) {
      setState(() {
        isUploading = false;
        message = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Cars to Firebase'),
        backgroundColor: const Color(0xFF0066FF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                uploadComplete ? Icons.check_circle : Icons.cloud_upload,
                size: 100,
                color: uploadComplete ? Colors.green : const Color(0xFF0066FF),
              ),
              const SizedBox(height: 32),
              Text(
                message,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (isUploading)
                const CircularProgressIndicator()
              else if (!uploadComplete)
                ElevatedButton(
                  onPressed: _uploadCars,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: const Text(
                    'UPLOAD NOW',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: const Text(
                    'DONE',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}