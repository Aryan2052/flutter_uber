import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'accept_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId; // Added verificationId

  const OtpPage({super.key, required this.phoneNumber, required this.verificationId});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _verifyOtp() async {
    String smsCode = _otpController.text.trim();

    if (smsCode.length == 6) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create PhoneAuthCredential
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: smsCode,
        );

        // Sign in the user
        await _auth.signInWithCredential(credential);

        setState(() {
          _isLoading = false;
        });

        // Navigate to AcceptPage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AcceptPage()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid 6-digit OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter the 6-digit code sent via SMS to ${widget.phoneNumber}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6, // Updated OTP length to 6 digits
              textAlign: TextAlign.center,
              decoration: InputDecoration(counterText: ""),
            ),
            SizedBox(height: 20),
            TextButton(onPressed: () {}, child: Text("Resend code via SMS")),
            TextButton(onPressed: () {}, child: Text("Call me with code")),
            Spacer(),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        onPressed: _verifyOtp,
                        child: Text("Verify & Continue"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
