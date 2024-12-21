import 'package:flutter/material.dart';

class Pro extends StatefulWidget {
  const Pro({super.key});

  @override
  State<Pro> createState() => _ProState();
}

class _ProState extends State<Pro> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Column(
        children: [
          SizedBox(height: 55),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Row(
                children: [
                  SizedBox(width: 130,),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),

              Positioned(
                child: Column(
                  children: [
                    SizedBox(height: 180,),
                    Text('Pankaj Patel', style: TextStyle(color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'pankaj.patel@yahoo.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
