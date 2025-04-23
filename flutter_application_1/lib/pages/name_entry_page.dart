import 'package:flutter/material.dart';
import 'accept_page_details.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameEntryPage extends StatefulWidget {
  final String email;

  const NameEntryPage({super.key, required this.email});

  @override
  _NameEntryPageState createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _saveName() async {
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your first name")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseService.saveUserDetails(
          user.uid,
          widget.email,
          _firstNameController.text,
          _lastNameController.text,
        );

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcceptPageDetails(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: widget.email,
            ),
          ),
        );
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving details: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What's your name?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text("Let us know how to properly address you."),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: "First name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: "Last name",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveName,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
