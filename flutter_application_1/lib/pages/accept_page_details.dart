import 'package:flutter/material.dart';
import 'landing_page.dart'; // Adjust path as needed

// Remove the existing LandingPage class to avoid conflicts

class AcceptPageDetails extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const AcceptPageDetails({super.key, 
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  _AcceptPageDetailsState createState() => _AcceptPageDetailsState();
}

class _AcceptPageDetailsState extends State<AcceptPageDetails> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, size: 40, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Accept Uber's Terms & Review Privacy Notice",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "By selecting \"I Agree\" below, I have reviewed and agree to the ",
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () {}, // Add link action
              child: Text(
                "Terms of Use",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            Text(" and acknowledge the ", style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () {}, // Add link action
              child: Text(
                "Privacy Notice.",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Text("I am at least 18 years of age.", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                Text("I Agree", style: TextStyle(fontSize: 16)),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed: isChecked
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LandingPage()),
                          );
                        }
                      : null,
                  child: Row(
                    children: [
                      Text("Next"),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
