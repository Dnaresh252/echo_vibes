import 'dart:ui';


import 'package:echovibes/screens/loginscreen.dart';
import 'package:echovibes/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(167, 211, 223, 1),
      body:Column(
        children: [
          SvgPicture.asset(
            'assets/undraw_breaking_barriers_vnf3.svg',
            height: 500,
            width: 200.0,
          ),
          const SizedBox(height: 10,),
          Center(

            child: Text("Join us and start creating your path to self-growth.",style: GoogleFonts.playfairDisplay(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,

              )


            ),
                textAlign : TextAlign.center

            ),
          ),
          
          const SizedBox(height: 60,),
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>const Loginscreen()));
            },
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,

              ),
              child: Center(
                child: Text("Login",style: GoogleFonts.inter(color: Colors.white
                ,fontWeight: FontWeight.bold),),
              ),

            ),
          ),
          const SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account ?",style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 13

              ),),
              const SizedBox(width: 2,),
              GestureDetector(
                   onTap: ()
                  {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>const Signup()));
                  },
                  child: Text("Sign up",style: GoogleFonts.inter(color: const Color.fromRGBO(106, 156, 137, 1),
                  fontSize: 16,
                    fontWeight: FontWeight.bold

                  ),))
            ],
          ),
        ],
      )
    );
  }
}
