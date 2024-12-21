

import 'firstpage.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(_createFadeTransitionRoute());
    });
  }

  PageRouteBuilder _createFadeTransitionRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  const Firstpage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
        var opacityAnimation = tween.animate(curvedAnimation);

        return FadeTransition(opacity: opacityAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You can replace this with your logo or image
          Center(child: Image(image: AssetImage('assets/Echo.png'))),
          SizedBox(height: 20),

        ],
      ),
    );
  }
}
