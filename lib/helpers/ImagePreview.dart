import 'dart:io';
import 'package:damagedetection1/helpers/getCurrentPosition.dart';
import 'package:damagedetection1/helpers/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ImagePreview extends StatefulWidget {
  String OriginalPath;
  Function incrementIndex;
  Function updateResult;

  ImagePreview(this.OriginalPath, this.incrementIndex, this.updateResult,
      {Key? key})
      : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    print("////////////////////////////////////////////////////////");
    // print(File(widget.OriginalPath).lengthSync());
    print("goahead");
    print(widget.OriginalPath);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(96, 82, 82, 82),
          body: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ResWidth(300),
                  child: Image.network(widget.OriginalPath),
                ),
                SizedBox(
                  width: ResWidth(12),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () async {
                              var location = await determinePosition();
                              DateTime currentPhoneDate = DateTime.now();
                              widget.updateResult(
                                  widget.OriginalPath,
                                  currentPhoneDate.toString(),
                                  "${location.latitude};${location.longitude}");
                              widget.incrementIndex();
                              Get.back();
                            },
                            icon: Icon(
                              Icons.task_alt,
                              color: Colors.green,
                              size: 40,
                            )),
                        SizedBox(
                          height: ResHeight(4),
                        ),
                        Text(
                          "Confirm",
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.replay,
                              color: Colors.red,
                              size: 40,
                            )),
                        SizedBox(
                          height: ResHeight(4),
                        ),
                        Text(
                          "Retake",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
// class _ImagePreviewState extends State<ImagePreview> {
//   String? _src;
//
//   void _handleUpload() {
//     final uploader = html.FileUploadInputElement()..accept = 'image/*';
//     uploader.click();
//
//     uploader.onChange.listen((e) {
//       if (uploader.files!.isEmpty) return;
//
//       final reader = html.FileReader();
//       reader.readAsDataUrl(uploader.files![0]);
//       reader.onLoadEnd.listen((e) {
//         setState(() {
//           _src = reader.result as String;
//           widget.OriginalPath = _src!;
//         });
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color.fromARGB(96, 82, 82, 82),
//         body: Padding(
//           padding: EdgeInsets.all(2.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_src != null)
//                 Container(
//                   width: ResWidth(300),
//                   child: Image.memory(base64Decode(_src!.split(',').last)),
//                 ),
//               SizedBox(
//                 width: ResWidth(12),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () async {
//                           var location = await determinePosition();
//                           DateTime currentPhoneDate = DateTime.now();
//                           widget.updateResult(
//                               widget.OriginalPath,
//                               currentPhoneDate.toString(),
//                               "${location.latitude};${location.longitude}");
//                           widget.incrementIndex();
//                           Get.back();
//                         },
//                         icon: Icon(
//                           Icons.task_alt,
//                           color: Colors.green,
//                           size: 40,
//                         ),
//                       ),
//                       SizedBox(
//                         height: ResHeight(4),
//                       ),
//                       Text(
//                         "Confirm",
//                         style: TextStyle(color: Colors.green, fontSize: 16),
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       IconButton(
//                         onPressed: _handleUpload,
//                         icon: Icon(
//                           Icons.replay,
//                           color: Colors.red,
//                           size: 40,
//                         ),
//                       ),
//                       SizedBox(
//                         height: ResHeight(4),
//                       ),
//                       Text(
//                         "Retake",
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       )
//                     ],
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
