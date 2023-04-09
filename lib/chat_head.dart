// import 'dart:developer';
// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// class MessengerChatHead extends StatefulWidget {
//   const MessengerChatHead({Key? key}) : super(key: key);
//
//   @override
//   State<MessengerChatHead> createState() => _MessengerChatHeadState();
// }
//
// class _MessengerChatHeadState extends State<MessengerChatHead> {
//   Color color = const Color(0xFFFFFFFF);
//   bool _isImageLoaded = false;
//   bool _isAudioPlaying = false;
//   final player = AudioPlayer();
//   String image = "https://i.ibb.co/HYL3NCV/300px-Rotating-earth-large.gif";
//   static const String _kPortNameOverlay = 'OVERLAY';
//   static const String _kPortNameHome = 'UI';
//   final _receivePort = ReceivePort();
//   SendPort? homePort;
//   String? messageFromOverlay;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (homePort != null) return;
//     final res = IsolateNameServer.registerPortWithName(
//       _receivePort.sendPort,
//       _kPortNameOverlay,
//     );
//     log("$res : HOME");
//     _receivePort.listen((message) {
//       log("message from UI: $message");
//       setState(() {
//         messageFromOverlay = 'message from UI: $message';
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }
//
//   void _onImageLoad() async {
//     setState(() {
//       _isImageLoaded = true;
//     });
//
//     if (!_isAudioPlaying) {
//       _playAudio();
//     }
//   }
//
//   void _playAudio() async {
//     if (_isImageLoaded) {
//       if (image == "https://i.ibb.co/HYL3NCV/300px-Rotating-earth-large.gif") {
//         await player.play(AssetSource("file2.mp3"));
//       } else {
//         await player.play(AssetSource("file1.mp3"));
//       }
//
//       setState(() {
//         _isAudioPlaying = true;
//       });
//       debugPrint('Play Audio');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (image ==
//             "https://i.ibb.co/HYL3NCV/300px-Rotating-earth-large.gif") {
//           image = "https://i.ibb.co/HTYbghW/anya-loading.gif";
//           _isImageLoaded = false;
//           _isAudioPlaying = false;
//           setState(() {});
//         } else {
//           image = "https://i.ibb.co/HYL3NCV/300px-Rotating-earth-large.gif";
//           _isImageLoaded = false;
//           _isAudioPlaying = false;
//           setState(() {});
//         }
//       },
//       child: CachedNetworkImage(
//         imageUrl: image,
//         imageBuilder: (context, imageProvider) {
//           if (!_isImageLoaded) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _onImageLoad();
//             });
//           }
//           return Image(image: imageProvider);
//         },
//       ),
//     );
//   }
// }

import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MessengerChatHead extends StatefulWidget {
  const MessengerChatHead({Key? key}) : super(key: key);

  @override
  State<MessengerChatHead> createState() => _MessengerChatHeadState();
}

class _MessengerChatHeadState extends State<MessengerChatHead> {
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? messageFromOverlay;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _inputData = "";
  String idleImage = "https://i.ibb.co/HTYbghW/anya-loading.gif";
  String hearingImage = "https://i.ibb.co/Xx7tx00/ezgif-com-resize.gif";
  String currentImage = "";

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.deviceDefault,
    );
    currentImage = hearingImage;
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    currentImage = idleImage;
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _inputData = result.recognizedWords;
      FlutterOverlayWindow.resizeOverlay(
        (WindowSize.fullCover * 0.15).toInt().abs(),
        (WindowSize.fullCover * 0.13).toInt().abs(),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    currentImage = idleImage;
    if (!_speechEnabled) {
      _initSpeech();
    }
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
    _receivePort.listen((message) {
      setState(() {
        messageFromOverlay = 'message from UI: $message';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_inputData);

    return (_inputData.isEmpty || _inputData == "" || _inputData == " ")
        ? currentImage == hearingImage
            ? GestureDetector(
                onTap: () {
                  _stopListening();
                },
                child: SizedBox(
                  height: (WindowSize.fullCover * 0.04).abs(),
                  width: (WindowSize.fullCover * 0.04).abs(),
                  child: CachedNetworkImage(
                    imageUrl: currentImage,
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _speechToText.isNotListening
                      ? _startListening()
                      : _stopListening();
                },
                child: SizedBox(
                  height: (WindowSize.fullCover * 0.04).abs(),
                  width: (WindowSize.fullCover * 0.04).abs(),
                  child: CachedNetworkImage(
                    imageUrl: currentImage,
                  ),
                ),
              )
        : Container(
            constraints: BoxConstraints(
              maxWidth: (WindowSize.fullCover * 0.15).abs(),
              maxHeight: (WindowSize.fullCover * 0.13).abs(),
              minHeight: (WindowSize.fullCover * 0.08).abs(),
              minWidth: (WindowSize.fullCover * 0.08).abs(),
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: (WindowSize.fullCover * 0.04).abs(),
                      width: (WindowSize.fullCover * 0.04).abs(),
                      child: CachedNetworkImage(
                        imageUrl: currentImage,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8, right: 5),
                          child: ShapeOfView(
                            shape: BubbleShape(
                                position: BubblePosition.Left,
                                arrowPositionPercent: 0.5,
                                borderRadius: 16,
                                arrowHeight: 10,
                                arrowWidth: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Scrollbar(
                                    child: SingleChildScrollView(
                                      dragStartBehavior: DragStartBehavior.down,
                                      child: DefaultTextStyle(
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black),
                                        child: AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                                _inputData * 20,
                                                curve: Curves.easeIn,
                                                cursor: "...",
                                                speed: const Duration(
                                                    milliseconds: 50)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.grey,
                                  width: 1,
                                  height: 30,
                                  margin: const EdgeInsets.only(left: 2),
                                  // constraints: BoxConstraints(
                                  //     maxHeight:
                                  //         (WindowSize.fullCover * 0.1).abs(),
                                  //     minHeight: 30,
                                  //     minWidth: 1,
                                  //     maxWidth: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 14,
                            right: 8,
                            child: GestureDetector(
                                onTap: () {
                                  _inputData = "";
                                  currentImage = idleImage;
                                  FlutterOverlayWindow.resizeOverlay(
                                    (WindowSize.fullCover * 0.04).toInt().abs(),
                                    (WindowSize.fullCover * 0.04).toInt().abs(),
                                  );
                                  setState(() {});
                                },
                                child: Icon(Icons.clear))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

enum BubblePosition { Bottom, Top, Left, Right }

class BubbleShape extends Shape {
  final BubblePosition position;

  final double borderRadius;
  final double arrowHeight;
  final double arrowWidth;

  final double arrowPositionPercent;

  BubbleShape(
      {this.position = BubblePosition.Bottom,
      this.borderRadius = 12,
      this.arrowHeight = 10,
      this.arrowWidth = 10,
      this.arrowPositionPercent = 0.5});

  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  Path generatePath({required Rect rect}) {
    final Path path = Path();

    double topLeftDiameter = max(borderRadius, 0);
    double topRightDiameter = max(borderRadius, 0);
    double bottomLeftDiameter = max(borderRadius, 0);
    double bottomRightDiameter = max(borderRadius, 0);

    final double spacingLeft =
        position == BubblePosition.Left ? arrowHeight : 0;
    final double spacingTop = position == BubblePosition.Top ? arrowHeight : 0;
    final double spacingRight =
        position == BubblePosition.Right ? arrowHeight : 0;
    final double spacingBottom =
        position == BubblePosition.Bottom ? arrowHeight : 0;

    final double left = spacingLeft + rect.left;
    final double top = spacingTop + rect.top;
    final double right = rect.right - spacingRight;
    final double bottom = rect.bottom - spacingBottom;

    final double centerX = (rect.left + rect.right) * arrowPositionPercent;

    path.moveTo(left + topLeftDiameter / 2.0, top);
    //LEFT, TOP

    if (position == BubblePosition.Top) {
      path.lineTo(centerX - arrowWidth, top);
      path.lineTo(centerX, rect.top);
      path.lineTo(centerX + arrowWidth, top);
    }
    path.lineTo(right - topRightDiameter / 2.0, top);

    path.quadraticBezierTo(right, top, right, top + topRightDiameter / 2);
    //RIGHT, TOP

    if (position == BubblePosition.Right) {
      path.lineTo(
          right, bottom - (bottom * (1 - arrowPositionPercent)) - arrowWidth);
      path.lineTo(rect.right, bottom - (bottom * (1 - arrowPositionPercent)));
      path.lineTo(
          right, bottom - (bottom * (1 - arrowPositionPercent)) + arrowWidth);
    }
    path.lineTo(right, bottom - bottomRightDiameter / 2);

    path.quadraticBezierTo(
        right, bottom, right - bottomRightDiameter / 2, bottom);
    //RIGHT, BOTTOM

    if (position == BubblePosition.Bottom) {
      path.lineTo(centerX + arrowWidth, bottom);
      path.lineTo(centerX, rect.bottom);
      path.lineTo(centerX - arrowWidth, bottom);
    }
    path.lineTo(left + bottomLeftDiameter / 2, bottom);

    path.quadraticBezierTo(left, bottom, left, bottom - bottomLeftDiameter / 2);
    //LEFT, BOTTOM

    if (position == BubblePosition.Left) {
      path.lineTo(
          left, bottom - (bottom * (1 - arrowPositionPercent)) + arrowWidth);
      path.lineTo(rect.left, bottom - (bottom * (1 - arrowPositionPercent)));
      path.lineTo(
          left, bottom - (bottom * (1 - arrowPositionPercent)) - arrowWidth);
    }
    path.lineTo(left, top + topLeftDiameter / 2);

    path.quadraticBezierTo(left, top, left + topLeftDiameter / 2, top);

    path.close();

    return path;
  }
}

abstract class Shape {
  Path build({Rect? rect, double? scale});
}

abstract class BorderShape {
  void drawBorder(Canvas canvas, Rect rect);
}

class ShapeOfViewBorder extends ShapeBorder {
  final Shape shape;

  const ShapeOfViewBorder({required this.shape});

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.all(0);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return shape.build(rect: rect, scale: 1);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (shape is BorderShape) {
      (shape as BorderShape).drawBorder(canvas, rect);
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final ShapeOfViewBorder typedOther = other;
    return shape == typedOther.shape;
  }

  @override
  int get hashCode => shape.hashCode;

  @override
  String toString() {
    return '$runtimeType($shape)';
  }
}

class ShapeOfView extends StatelessWidget {
  final Widget? child;
  final Shape? shape;
  final double elevation;
  final Clip clipBehavior;
  final double? height;
  final double? width;

  const ShapeOfView({
    Key? key,
    this.child,
    this.elevation = 4,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: ShapeOfViewBorder(shape: shape!),
      clipBehavior: clipBehavior,
      elevation: elevation,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, right: 30, left: 18, bottom: 8),
        child: SizedBox(
          height: height,
          width: width,
          child: child,
        ),
      ),
    );
  }
}
