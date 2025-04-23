import 'package:flutter/material.dart';
import 'name_entry_page.dart'; // Navigate to Name Entry Page

class OtpEmailPage extends StatefulWidget {
  final String email;

  const OtpEmailPage({super.key, required this.email});

  @override
  _OtpEmailPageState createState() => _OtpEmailPageState();
}

class _OtpEmailPageState extends State<OtpEmailPage> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyOtp() {
    if (_otpController.text.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NameEntryPage(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid 4-digit OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Email OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter the 4-digit code sent to ${widget.email}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: InputDecoration(counterText: ""),
            ),
            SizedBox(height: 20),
            TextButton(onPressed: () {}, child: Text("Resend code")),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  child: Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
