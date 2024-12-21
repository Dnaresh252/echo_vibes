import 'dart:async';
import 'dart:math';
import 'package:echovibes/firbaseservice.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SentimentScreen extends StatefulWidget {
  const SentimentScreen({super.key});


  @override

  _SentimentScreenState createState() => _SentimentScreenState();
}

class _SentimentScreenState extends State<SentimentScreen> {
  final TextEditingController _textController = TextEditingController();
  String _responseText = "";
  bool _isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  final List<Map<String, dynamic>> _emotionList = [];
  Random random = Random();

  bool _showEmoji = false;
  double _topPosition = 200;
  double _opacity = 1.0;
  String _lottieFile = 'assets/neutralo.json';

  Color containerColor = Colors.blueAccent.withOpacity(0.1);
  Color borderColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _textController.removeListener(_handleTextChange);
    _textController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    // No setState here to prevent full rebuilds on every character input
  }

  Color getRandomLightColor() {
    return Color.fromRGBO(
      random.nextInt(50) + 180,
      random.nextInt(50) + 180,
      random.nextInt(50) + 180,
      1.0,
    );
  }

  Color getRandomDarkColor() {
    return Color.fromRGBO(
      random.nextInt(55) + 70,
      random.nextInt(55) + 70,
      random.nextInt(55) + 70,
      1.0,
    );
  }

  Future<void> _sendText() async {
    final String inputText = _textController.text;

    if (inputText.isEmpty) return;

    final url = Uri.parse('http://10.0.2.2:5000/analyze');
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": inputText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final emotion = data['emotion'];
        final now = DateTime.now();
        final formattedDate = DateFormat('d MMMM yyyy').format(now);
        final formattedTime = DateFormat('h:mm a').format(now);

        setState(() {
          containerColor = getRandomLightColor();
          borderColor = getRandomDarkColor();

          _firebaseService.storeSentimentData(
            inputText,
            emotion,
            formattedDate,
            formattedTime,
            containerColor,
            borderColor,
          );

          _responseText = "Detected Emotion: $emotion";
          _isLoading = false;
          _showEmojiTemporarily(emotion);
        });
      } else {
        setState(() {
          _responseText = "Error: Could not retrieve sentiment. Status Code: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _responseText = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  void _showEmojiTemporarily(String emotion) {
    switch (emotion) {
      case 'happy':
        _lottieFile = 'assets/happylo.json';
        break;
      case 'sad':
        _lottieFile = 'assets/angrylo.json';
        break;
      case 'angry':
        _lottieFile = 'assets/sadlo.json';
        break;
      default:
        _lottieFile = 'assets/neutralo.json';
    }

    setState(() {
      _showEmoji = true;
      _topPosition = 200;
      _opacity = 1.0;
    });

    Timer(const Duration(seconds: 1), () {
      setState(() {
        _topPosition = 0;
        _opacity = 0.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showEmoji = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _firebaseService.fetchSentimentDataStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No sentiment data available."));
                      }

                      final sentiments = snapshot.data!.reversed.toList();
                      return ListView.builder(
                        itemCount: sentiments.length,
                        itemBuilder: (context, index) {
                          final entry = sentiments[index];
                          final emotion = entry['emotion'] ?? 'Neutral';
                          Color containerColor = Color(entry['containerColor']);
                          Color borderColor = Color(entry['borderColor']);

                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry['text'] ?? "",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.0),
                                        color: containerColor,
                                        border: Border.all(color: borderColor, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(Icons.calendar_month_sharp, size: 15, color: Colors.black54),
                                          Text(
                                            "${entry['date'] ?? 'N/A'}",
                                            style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 70,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.0),
                                        color: containerColor,
                                        border: Border.all(color: borderColor, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          emotion == 'happy'
                                              ? SvgPicture.asset('assets/happy.svg', height: 17, width: 20)
                                              : emotion == 'sad'
                                              ? SvgPicture.asset('assets/sad.svg', height: 17, width: 20)
                                              : emotion == 'angry'
                                              ? SvgPicture.asset('assets/angry.svg', height: 17, width: 20)
                                              : SvgPicture.asset('assets/neutral.svg', height: 17, width: 20),
                                          const SizedBox(width: 5),
                                          Text(
                                            emotion,
                                            style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.0),
                                        color: containerColor,
                                        border: Border.all(color: borderColor, width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 7),
                                          SvgPicture.asset('assets/clock-history.svg', height: 15, width: 20),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${entry['time'] ?? 'N/A'}",
                                            style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,

                          decoration: InputDecoration(

                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.black54, width: 2.0),
                            ),
                            suffixIcon: ValueListenableBuilder(
                              valueListenable: _textController,
                              builder: (context, TextEditingValue value, child) {
                                return value.text.isEmpty
                                    ? IconButton(
                                  icon: const Icon(Icons.mic, color: Colors.black54),
                                  onPressed: () {
                                    print("Microphone activated");
                                  },
                                )
                                    : IconButton(
                                  icon: const Icon(Icons.send, color: Colors.black54),
                                  onPressed: () {
                                    _sendText();
                                    _textController.clear();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showEmoji)
            AnimatedPositioned(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              top: _topPosition,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: _opacity,
                child: Lottie.asset(
                  _lottieFile,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
