// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class TestScaffold extends StatefulWidget {
//   TestScaffold({Key? key}) : super(key: key);
//
//   @override
//   State<TestScaffold> createState() => _TestScaffoldState();
// }
//
// class _TestScaffoldState extends State<TestScaffold> {
//   var excel;
//
//   // /data/user/0/com.example.untitled/app_flutter
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   //ask for permission
//                   await Permission.manageExternalStorage.request();
//                   var status = await Permission.manageExternalStorage.status;
//                   if (status.isDenied) {
//                     // We didn't ask for permission yet or the permission has been denied   before but not permanently.
//                     return;
//                   }
//
//                   if (await Permission.storage.isRestricted) {
//                     // The OS restricts access, for example because of parental controls.
//                     return;
//                   }
//                   if (status.isGranted) {
//                     excel = Excel.decodeBytes(
//                         File("/storage/emulated/0/n.xlsx").readAsBytesSync());
//                   }
//                 },
//                 child: const Text('Create Excel')),
//           ),
//           Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   Sheet sheetObject = excel['Sheet1'];
//                   List<String> dataList = [
//                     "Google",
//                     "loves",
//                     "Flutter",
//                     "and",
//                     "Flutter",
//                     "loves",
//                     "Excel"
//                   ];
//                   sheetObject.insertRowIterables(dataList, 8);
//                   setState(() {});
//                 },
//                 child: const Text('Save Excel')),
//           ),
//           Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   var fileBytes = excel.save();
//
//                   File("/storage/emulated/0/n.xlsx")
//                     ..createSync(recursive: true)
//                     ..writeAsBytesSync(fileBytes);
//                 },
//                 child: const Text('Save Excel')),
//           ),
//         ],
//       ),
//     );
//   }
// }
