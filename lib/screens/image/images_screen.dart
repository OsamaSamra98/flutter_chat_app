// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ImagesScreen extends StatefulWidget {
//   const ImagesScreen({Key? key}) : super(key: key);
//
//   @override
//   _ImagesScreenState createState() => _ImagesScreenState();
// }
//
// class _ImagesScreenState extends State<ImagesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Images',
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
//             onPressed: () =>
//                 Navigator.pushNamed(context, '/upload_image_screen'),
//             icon: const Icon(Icons.camera_alt),
//           ),
//         ],
//       ),
//       body: GridView.builder(
//         itemCount: 5,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         itemBuilder: (context, index) {
//           return Card(
//             clipBehavior: Clip.antiAlias,
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Stack(
//               children: [
//                 // CachedNetworkImage(
//                 //   width: double.infinity,
//                 //   fit: BoxFit.cover,
//                 //   imageUrl: ApiSettings.imagesUrl +
//                 //       controller.images[index].image,
//                 //   placeholder: (context, url) =>
//                 //   const CircularProgressIndicator(),
//                 //   errorWidget: (context, url, error) =>
//                 //   const Icon(Icons.error),
//                 // ),
//                 Align(
//                   alignment: AlignmentDirectional.bottomCenter,
//                   child: Container(
//                     width: double.infinity,
//                     height: 50,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     color: Colors.black38,
//                     alignment: AlignmentDirectional.centerEnd,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             'IMage name',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () async => await deleteImage(imageId: 1),
//                           color: Colors.red.shade400,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> deleteImage({required int imageId}) async {}
// }
