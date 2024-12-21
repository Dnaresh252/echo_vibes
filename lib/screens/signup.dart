import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginscreen.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  Future<User?> _signUpWithGoogle() async {
    try {
      // Start the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // If the sign-in is aborted

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing up with Google: $e");
      return null;
    }
  }


  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': _username.text,
          'email': _email.text,
          'password': _password.text,
        });

        _showCustomDialog(context);
      } catch (e) {
        _showErrorDialog("Error: ${e.toString()}");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(167, 211, 223, 1),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Lottie.asset(
                  'assets/Animation - 1729686586998.json',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.27,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: FittedBox(
                    child: Text(
                      "Believe in the magic of",
                      style: GoogleFonts.playfairDisplay(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 130),
                  child: FittedBox(
                    child: Text(
                      "new beginnings.",
                      style: GoogleFonts.playfairDisplay(
                        textStyle: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                GestureDetector(
                  onTap: _signUpWithGoogle,
                  child: Container(
                    height: screenHeight * 0.045,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/google-icon-logo-svgrepo-com.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Sign up with Google",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.2,
                      height: 1,
                      color: Colors.black38,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "or",
                      style: GoogleFonts.roboto(color: Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: screenWidth * 0.2,
                      height: 1,
                      color: Colors.black38,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),

                // Form for validation
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField("Username*", _username, "Enter your username",validateUsername),
                      _buildTextFormField("Email*", _email, "Enter your email", _validateEmail),
                      _buildPasswordField("Password*", _password, "Enter your password"),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Signup Button
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    width: screenWidth * 0.6,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Loginscreen()),
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, String hintText, String? Function(String?)? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromRGBO(37, 113, 128, 1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            hintStyle: GoogleFonts.inter(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
      return 'Username must contain at least one number';
    }
    return null; // Valid username
  }


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  Widget _buildPasswordField(String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromRGBO(37, 113, 128, 1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            hintStyle: GoogleFonts.inter(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return "Password must be at least 6 characters long.";
            }
            return null;
          },
        ),
      ],
    );
  }
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromRGBO(212, 246, 255,1), // Background color of the dialog
          child: SizedBox(

            height: 200, // Adjust height as needed
            child: Column(

              children: [

                const SizedBox(height: 20),
                const Text(
                  "All Done! Ready to Dive In?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                    "Your future is created by what you do today, not tomorrow.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sahitya(
                        textStyle: const TextStyle()
                    )
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>const Loginscreen()));
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20)),
                    child: Center(child:
                    Text("Go to Login",style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10
                    ),),),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
