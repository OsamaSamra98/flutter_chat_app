// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vp10_firebase/utils/helper.dart';
// class UploadImageScreen extends StatefulWidget {
//   const UploadImageScreen({Key? key}) : super(key: key);
//
//   @override
//   _UploadImageScreenState createState() => _UploadImageScreenState();
// }
//
// class _UploadImageScreenState extends State<UploadImageScreen> with Helper {
//   late ImagePicker _imagePicker;
//   XFile? _pickedFile;
//   double? _progressValueColor = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _imagePicker = ImagePicker();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Upload Image',
//           style: GoogleFonts.cairo(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             onPressed: () => print('OPEN CAMERA'),
//             icon: const Icon(Icons.camera_front),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           LinearProgressIndicator(
//             minHeight: 10,
//             value: _progressValueColor,
//             color: Colors.green.shade800,
//             backgroundColor: Colors.blue.shade200,
//           ),
//           Expanded(
//             child: _pickedFile != null
//                 ? Image.file(File(_pickedFile!.path))
//                 : Center(
//                     child: IconButton(
//                       onPressed: () async => await pickImage(),
//                       icon: const Icon(Icons.camera),
//                     ),
//                   ),
//           ),
//           ElevatedButton.icon(
//             onPressed: () async => await performImageUpload(),
//             icon: const Icon(Icons.cloud_upload),
//             label: const Text('Upload Image'),
//             style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> pickImage() async {
//     XFile? pickedImageFile = await _imagePicker.pickImage(
//         source: ImageSource.camera, imageQuality: 50);
//     if (pickedImageFile != null) {
//       setState(() {
//         _pickedFile = pickedImageFile;
//       });
//     }
//   }
//
//   Future<void> performImageUpload() async {
//     if (checkData()) {
//       await uploadImage();
//     }
//   }
//
//   bool checkData() {
//     if (_pickedFile != null) {
//       return true;
//     }
//     // showSnackBar(context, message: 'Pick image first', error: true);
//     return false;
//   }
//
//   Future<void> uploadImage() async {
//     changeProgressValue(value: null);
//    /* ImagesGetxController.to.uploadImage(
//       context,
//       file: File(_pickedFile!.path),
//       listener: (
//           {required String message,
//           required bool status,
//           StudentImage? studentImage}) {
//         showSnackBar(context, message: message, error: !status);
//         if (status) {
//           changeProgressValue(value: 1);
//         }else{
//           changeProgressValue(value: 0);
//         }
//       },
//     );*/
//   }
//
//   void changeProgressValue({double? value}) {
//     setState(() {
//       _progressValueColor = value;
//     });
//   }
// }
