import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echovibes/screens/forgetpassword.dart';
import 'package:echovibes/screens/homescreen.dart';
import 'package:echovibes/screens/sentimentscrren.dart';
import 'package:echovibes/screens/signup.dart';
import 'package:echovibes/screens/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Save login status
      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to HomeScreen and replace LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SentimentScreen()),
        );
      }
    } catch (e) {
      _showError("Google Sign-In failed. Please try again.");
    }
  }

  Future<void> _login() async {
    final usernameOrEmail = _usernameOrEmailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      UserCredential userCredential;
      if (_isEmail(usernameOrEmail)) {
        // Login with email
        userCredential = await _auth.signInWithEmailAndPassword(
          email: usernameOrEmail,
          password: password,
        );
      } else {
        // Login with username
        String? email = await _getEmailFromUsername(usernameOrEmail);
        if (email == null) {
          _showError("User not found");
          return;
        }
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      // Save login status
      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to HomeScreen and replace LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Test()),
        );
      }
    } catch (e) {
      _showError("Login failed. Please check your credentials.");
    }
  }


  bool _isEmail(String input) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(input);
  }

  Future<String?> _getEmailFromUsername(String username) async {
    // Example Firestore query to get the email for a username
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs.first.get('email');
    }
    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(167, 211, 223, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Lottie.asset(
                  'assets/Animation - 1729614473014.json',
                  width: screenWidth * 0.8, // 80% of the screen width
                  height: screenHeight * 0.3, // 30% of the screen height
                  fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.03), // Adjust the spacing here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome back to Echoo",
                      style: GoogleFonts.sahitya(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      " Vibes! 🌟",
                      style: GoogleFonts.sahitya(
                        textStyle: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.05,),
                GestureDetector(
                  onTap: _loginWithGoogle,
                  child: Container(
                    height:screenHeight*0.045,
                    width: screenWidth*0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,

                        )

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/google-icon-logo-svgrepo-com.svg',
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Sign in with Google",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.2,
                      height: 1,
                      color: Colors.black38,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "or",
                      style: GoogleFonts.roboto(color: Colors.black54),
                    ),
                    SizedBox(width: 6),
                    Container(
                      width: screenWidth * 0.2,
                      height: 1,
                      color: Colors.black38,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),

                SizedBox(height: screenHeight * 0.01), // Adjust dynamic spacing
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username or email*",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.045,
                  child: TextField(
                    controller: _usernameOrEmailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(37, 113, 128, 1),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      prefixIcon: Icon(Icons.person_outline, size: 15),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password*",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: screenWidth * 0.8,
                  height: 45,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(37, 113, 128, 1),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      prefixIcon: const Icon(Icons.password, size: 15),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          size: 15,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
                    },
                    child: Text(
                      "Forget Password?",
                      style: GoogleFonts.inter(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                // Forget Password, Login Button, and other UI elements...

                GestureDetector(
                  onTap: _login, // Call the login function on tap
                  child: Container(
                    width: screenWidth * 0.6,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "Login",
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
                    Text("Don't have  an account ?",style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Colors.black54
                    ),),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                      },
                      child: Text("Sign up",style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black
                      ),),
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
}
