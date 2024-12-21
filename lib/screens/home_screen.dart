import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:echovibes/Providers/color_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:echovibes/Providers/like_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterTts ffTts = FlutterTts();
  List<GlobalKey> _captureKeys = [];
  final List<String> screens = [
    'Believe in yourself,',
    'The secret of getting ahead is getting started',
    'You don\'t have to be great to start, but you have to start to be great',
    'It always seems impossible until it’s done',
    "Believe you can and you’re halfway there.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "Success is not final; failure is not fatal: It is the courage to continue that counts.",
    "Dream big and dare to fail.",
    "Do something today that your future self will thank you for.",
    "Hardships often prepare ordinary people for an extraordinary destiny.",
    "Success is walking from failure to failure with no loss of enthusiasm.",
    "It’s not about perfect. It’s about effort, and when you bring that effort every single day, that’s where transformation happens.",
    "Your limitation—it’s only your imagination.",
    "The journey of a thousand miles begins with one step."
        'The only way to do great work is to love what you do',
    'Don\'t watch the clock; do what it does. Keep going'
  ];

  @override
  void initState() {
    _captureKeys = List.generate(screens.length, (index) => GlobalKey());
    initTts();
    Provider.of<LikeProvider>(context, listen: false)
        .genreateLike(screens.length);
    super.initState();
  }

  void initTts() async {
    await ffTts.setLanguage("en-IN");
    await ffTts.setSpeechRate(0.55);
    await ffTts.setPitch(0.95);
    await ffTts.setVoice({"name": "en-in-x-ene-local", "locale": "en-IN"});
  }

  void _stopTts() async {
    await ffTts.stop();
  }

  void _speak(String text) async {
    await ffTts.speak(text);
  }

  Future<void> _shareImageWithText(String text, int index) async {
    try {
      RenderRepaintBoundary boundary = _captureKeys[index]
          .currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) return;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote_image.png').create();
      await file.writeAsBytes(pngBytes);

      final XFile xFile = XFile(file.path);
      await Share.shareXFiles([xFile]);
    } catch (e) {
      print("Error sharing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalHeight = MediaQuery.of(context).size.height;
    final double totalWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final colorProvider = Provider.of<ColorProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: screens.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              colorProvider.generateRandomGradient();
              _stopTts();
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: () {
                  Provider.of<LikeProvider>(context, listen: false)
                      .makeLiked(index);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RepaintBoundary(
                      key: _captureKeys[index],
                      child: Container(
                        width: totalWidth,
                        height: totalHeight,
                        decoration: BoxDecoration(
                          color: colorProvider.currentColor
                        ),
                        child: Align(
                          alignment: const Alignment(0, -0.05),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            child: Text(
                              screens[index],
                              style: GoogleFonts.poppins(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(child:
                        Consumer<LikeProvider>(builder: (context, like, child) {
                      if (like.isDobuleTapped) {
                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, -50 * value),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 50 + (50 * value),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    })),
                    Positioned(
                      bottom: totalHeight * 0.03,
                      child: Container(
                        width: totalWidth * 0.7,
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: totalWidth * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _shareImageWithText(screens[index], index);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.ios_share,
                                    size: totalWidth * 0.08,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: totalWidth * 0.035),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: totalWidth * 0.1),
                            Consumer<LikeProvider>(
                              builder: (context, like, child) =>
                                  GestureDetector(
                                onTap: () {
                                  like.toggle(index);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      like.isLiked(index)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: like.isLiked(index)
                                          ? Colors.red
                                          : Colors.black,
                                      size: totalWidth * 0.08,
                                    ),
                                    Text(
                                      'Like',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: totalWidth * 0.035),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: totalWidth * 0.1),
                            GestureDetector(
                              onTap: () {
                                _speak(screens[index]);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.volume_up,
                                    color: Colors.black,
                                    size: totalWidth * 0.08,
                                  ),
                                  Text(
                                    'Speak out',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: totalWidth * 0.035),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: totalWidth * 0.02,
            top: statusBarHeight + 4,
            child: Container(
              height: totalHeight * 0.05,
              width: totalHeight * 0.05,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => ));
                  },
                  icon: const Icon(Icons.menu)),
            ),
          ),
          Positioned(
            right: totalWidth * 0.02,
            top: statusBarHeight + 4,
            child: Row(
              children: [
                Container(
                  height: totalHeight * 0.05,
                  width: totalHeight * 0.05,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.card_giftcard_sharp)),
                ),
                SizedBox(width: totalWidth * 0.02),
                Container(
                  height: totalHeight * 0.05,
                  width: totalHeight * 0.05,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.account_circle)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
