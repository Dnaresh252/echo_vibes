import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); 

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to Home Screen!"),
      ),
    );
  }
}
