import 'package:echovibes/firebase_options.dart';
import 'package:echovibes/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:echovibes/Providers/color_provider.dart';
import 'package:echovibes/Providers/like_provider.dart';
// import 'package:echovibes/screens/forgetpassword.dart';
// import 'package:echovibes/screens/loginscreen.dart';
// import 'package:echovibes/screens/sentimentscrren.dart';
// import 'package:echovibes/screens/signup.dart';
// import 'package:echovibes/screens/splashscreen.dart';
// import 'package:echovibes/screens/subscription.dart';
// import 'package:echovibes/screens/test.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LikeProvider()),
      ChangeNotifierProvider(create: (_) => ColorProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeScreen(),
    );
  }
}
