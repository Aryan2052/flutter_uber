import 'package:flutter/material.dart';
import 'landing_page.dart'; // Import LandingPage

class AcceptPage extends StatefulWidget {
  const AcceptPage({super.key});

  @override
  _AcceptPageState createState() => _AcceptPageState();
}

class _AcceptPageState extends State<AcceptPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Terms & Privacy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.assignment, size: 50, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              "Accept Uber's Terms & Review Privacy Notice",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "By selecting 'I Agree' below, I have reviewed and agree to the Terms of Use and acknowledge the Privacy Notice. I am at least 18 years of age.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text("I Agree"),
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Back"),
                ),
                ElevatedButton(
                  onPressed: _isChecked
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandingPage()),
                          );
                        }
                      : null,
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
