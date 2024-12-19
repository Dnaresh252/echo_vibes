import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with gradient overlay for a smooth transition
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white, // Original image colors
                    Colors.black.withOpacity(0.6), // Fading to black
                  ],
                  stops: [0.6, 1.0], // Adjust these stops for a smooth blend
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Image.network(
                "https://cdn.pixabay.com/photo/2023/07/13/16/32/woman-8125236_640.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom gradient container for a seamless transition
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(197, 184, 175,0.6), // Matching top fade
                    Color.fromRGBO(197, 184, 175,1), // Final background color
                  ],
                  stops: [0.0, 1.0], // Seamless transition without lines
                ),
              ),

            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.55,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Unlock the Power of",style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 30,
                    ),),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 20.0),

                    child: Text("  Premium Affirmations Today!",style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 20,
                    ),),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 30.0,top: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/bahamut-svgrepo-com.svg',
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 13,),
                        Text("Unlock All Categories",style: GoogleFonts.playfairDisplay(
                          color: Color.fromRGBO(61, 83, 0,1),
                        ),)
                      ],
                    )

                  ),
                  Padding(
                      padding:  EdgeInsets.only(left: 30.0,top: 20),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/bahamut-svgrepo-com.svg',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 13,),
                          Text("Daily Affirmation Notifications",style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(61, 83, 0,1),
                          ),)
                        ],
                      )

                  ),Padding(
                      padding:  EdgeInsets.only(left: 30.0,top: 20),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/bahamut-svgrepo-com.svg',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 13,),
                          Text("Offline Access to Affirmationss",style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(61, 83, 0,1),
                          ),)
                        ],
                      )

                  ),
                  Padding(
                      padding:  EdgeInsets.only(left: 30.0,top: 20),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/bahamut-svgrepo-com.svg',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 13,),
                          Text("Progress Tracking and Insights",style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(61, 83, 0,1),
                          ),)
                        ],
                      )

                  ),
                  
                  // Padding(padding:EdgeInsets.only(top: 0,left: 20),
                  //
                  // child: Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SvgPicture.asset(
                  //       'yellow-star-15589.svg',
                  //       height: 30,
                  //       width: 20,
                  //     ),
                  //     SvgPicture.asset(
                  //       'yellow-star-15589.svg',
                  //       height: 20,
                  //       width: 20,
                  //     ),
                  //     SvgPicture.asset(
                  //       'yellow-star-15589.svg',
                  //       height: 20,
                  //       width: 20,
                  //     ),
                  //   ],
                  // )
                  //
                  //
                  // )


                ],
              )

          ),
          Positioned(
              
              top: MediaQuery.of(context).size.height * 0.88,
              left: MediaQuery.of(context).size.width*0.37,
              
              child: Column(
            children: [
              Text("7-day free, then",style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                color: Colors.black54
              ),),
              Text("200/year",style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold
              ),),


            ],
          )),
      Positioned(

        top: MediaQuery.of(context).size.height * 0.93,
        left: MediaQuery.of(context).size.width*0.15,

        child:Container(
          width: MediaQuery.of(context).size.width*0.7,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black54
          ),
          child: Center(
            child:Text("Try it for free",style: GoogleFonts.roboto(
              color: Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
          ),
        )

      )





        ],
      ),
    );
  }
}
