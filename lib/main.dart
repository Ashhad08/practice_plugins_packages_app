import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chart.dart';
import 'chat_head.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  listenForPermissions();
  runApp(const MyApp());
}

void listenForPermissions() async {
  final status = await Permission.microphone.status;
  switch (status) {
    case PermissionStatus.denied:
      requestForPermission();
      break;
    case PermissionStatus.granted:
      break;
    case PermissionStatus.limited:
      break;
    case PermissionStatus.permanentlyDenied:
      break;
    case PermissionStatus.restricted:
      requestForPermission();
      break;
  }
}

Future<void> requestForPermission() async {
  await Permission.microphone.request();
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  listenForPermissions();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessengerChatHead(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat GPT Overlay Bot',
      home: LineChartSample2(),
    );
  }
}
