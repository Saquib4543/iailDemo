import 'package:damagedetection1/helpers/color.dart';
import 'package:damagedetection1/helpers/getCurrentPosition.dart';
import 'package:damagedetection1/helpers/responsive.dart';
import 'package:damagedetection1/helpers/ImagePreview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CameraImageUpload extends StatefulWidget {
  bool showTopBanner;
  String appBarTitle;
  Function updateSingleImageData;
  int singleImageIndex;
  Function updateImageData;

  CameraImageUpload(
      this.updateImageData,
      this.showTopBanner,
      this.appBarTitle,
      this.updateSingleImageData,
      this.singleImageIndex,
      {Key? key})
      : super(key: key);

  @override
  State<CameraImageUpload> createState() => _CameraImageUploadState();
}

class _CameraImageUploadState extends State<CameraImageUpload> {
  int _currentIndex = 0;
  CarouselController imageCarouselController = CarouselController();

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  // }
  //
  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  void incrementCurrentIndex() {
    if (widget.showTopBanner) {
      Get.back();
    } else {
      if (_currentIndex == 10) {
        widget.updateImageData(returnListofMap);
        Get.back();
      }
      setState(() {
        _currentIndex = _currentIndex + 1;
      });

      imageCarouselController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  List<String> imageNameList = [
    "FrontSide",
    "FrontRightHandSide",
    "DriverSide",
    "RearRightHandSide",
    "RearSide",
    "RearLeftHandSide",
    "PassengerSide",
    "FrontLeftHandSide",
    "EngineCompart",
    "ChassisNo",
    "OdometerCar"
  ];
  List<String> imagePathList = [];
  List<String> thumbnailPathList = [];
  List<String> imagePathListPCPandPCV = [
    "assets/overlay/1_Front Side.png",
    "assets/overlay/2_Front Right-Hand Corner Side.png",
    "assets/overlay/3_Driver Full Side.png",
    "assets/overlay/4_Rear right-hand corner Side.png",
    "assets/overlay/5_Rear full Side.png",
    "assets/overlay/6_Rear left-hand corner Side.png",
    "assets/overlay/7_Passenger Side.png",
    "assets/overlay/8_Front Left-Hand Corner Side.png",
    "assets/overlay/blank.png",
    "assets/overlay/blank.png",
    "assets/overlay/blank.png",
  ];
  List<String> imagePathListOther = [
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
    "asset/overlay/blank.png",
  ];

  List<String> thumbnailPathListPCV = [
    "asset/thumbnail/Front_Inspection_Car.png",
    "asset/thumbnail/IsFrontRightHandSide.jpg",
    "asset/thumbnail/IsDriverSide.jpg",
    "asset/thumbnail/IsRearRightHandSide.jpg",
    "asset/thumbnail/IsRearSide.jpg",
    "asset/thumbnail/IsRearLeftHandSide.jpg",
    "asset/thumbnail/IsPassengerSide.jpg",
    "asset/thumbnail/IsFrontLeftHandSide.jpg",
    "asset/thumbnail/IsEngineCompart.jpg",
    "asset/thumbnail/IsChassisNo.jpg",
    "asset/thumbnail/IsOdometerCar.jpg",
  ];

  List<String> thumbnailPathListGCV = [
    "asset/thumbnail/GCV/Front_Inspection_CarGCV.jpg",
    "asset/thumbnail/GCV/IsFrontRightHandSide_GCV.jpg",
    "asset/thumbnail/GCV/IsDriverSide_GCV.jpg",
    "asset/thumbnail/GCV/IsRearRightHandSide_GCV.jpg",
    "asset/thumbnail/GCV/IsRearSide_GCV.jpg",
    "asset/thumbnail/GCV/IsRearLeftHandSide_GCV.jpg",
    "asset/thumbnail/GCV/IsPassengerSide_GCV.jpg",
    "asset/thumbnail/GCV/IsFrontLeftHandSide_GCV.jpg",
    "asset/thumbnail/GCV/IsEngineCompart_GCV.jpg",
    "asset/thumbnail/GCV/IsChassisNo.jpg",
    "asset/thumbnail/GCV/IsOdometerCar_GCV.jpg",
  ];

  List returnListofMap = [];
  void addToReturnList(path, time, location) {
    if (widget.showTopBanner) {
      widget.updateSingleImageData(
          widget.singleImageIndex, path, time, location);
    } else {
      setState(() {
        returnListofMap = [
          ...returnListofMap,
          {"imgPath": path, "timestamp": time, "location": location}
        ];
      });
    }
  }

  Widget imageRowChild(int idx, int imgIdx) {
    imagePathList = imagePathListPCPandPCV;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // imgIdx < idx
          // ? Icon(
          //     Icons.done_rounded,
          //     color: Colors.green,
          //   )
          // : Icon(
          //     Icons.warning_amber,
          //     color: Colors.amber,
          //   ),
          ////////////////////////////////////////////////////////////////
          // TextButton(
          //   onPressed: () => showDialog<String>(
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //       title: const Text('AlertDialog Title'),
          //       content: const Text('AlertDialog description'),
          //       actions: <Widget>[
          //         TextButton(
          //           onPressed: () => Navigator.pop(context, 'Cancel'),
          //           child: const Text('Cancel'),
          //         ),
          //         TextButton(
          //           onPressed: () => Navigator.pop(context, 'OK'),
          //           child: const Text('OK'),
          //         ),
          //       ],
          //     ),
          //   ),
          //   child: const Text('Show Dialog'),
          // ),
//////////////////////////////////
//           GestureDetector(
//             onTap: () => showDialog(
//               context: context,
//               builder: (BuildContext context) => AlertDialog(
//                 title: Container(
//                   color: red,
//                   child: Text(
//                     imageNameList[imgIdx],
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: white),
//                   ),
//                 ),
//                 content: Image.asset(
//                   thumbnailPathList[imgIdx],
//                   height: ResHeight(300),
//                   // fit: BoxFit.fill,
//                   width: ResWidth(100),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, 'OK'),
//                     child: Text(
//                       'OK',
//                       style: TextStyle(color: red),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             child: Image.asset(
//               thumbnailPathList[imgIdx],
//               width: ResWidth(50),
//               height: ResHeight(60),
//             ),
//           ),
/////////////////////////////
          // GestureDetector(
          // child: Image.asset(
          //   thumbnailPathList[imgIdx],
          //   width: ResWidth(50),
          //   height: ResHeight(30),
          // ),
          //   onTap: () {
          //     // AlertDialog(
          //     //   title: const Text('Popup example'),
          //     //   content: new Column(
          //     //     mainAxisSize: MainAxisSize.min,
          //     //     crossAxisAlignment: CrossAxisAlignment.start,
          //     //     children: <Widget>[
          //     //       Text("Hello"),
          //     //     ],
          //     //   ),
          //     //   actions: <Widget>[
          //     //     new FlatButton(
          //     //       onPressed: () {
          //     //         Navigator.of(context).pop();
          //     //       },
          //     //       textColor: Theme.of(context).primaryColor,
          //     //       child: const Text('Close'),
          //     //     ),
          //     //   ],
          //     // );
          //   },
          // ),

          SizedBox(
            height: ResHeight(0),
          ),
          Text(
            imageNameList[imgIdx],
            style: TextStyle(
                color: Colors.white,
                fontSize: imgIdx == idx ? 20 : 15,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: ResWidth(0),
          ),
        ],
      ),
    );
  }

  // Camera Code
  List<CameraDescription> cameras = [];
  CameraController controller = CameraController(
      const CameraDescription(
          name: "mibl_brekin",
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0),
      ResolutionPreset.high,
      enableAudio: true);

  // void cameraInit() async {
  //   cameras = await availableCameras();
  //   controller =
  //       CameraController(cameras[0], ResolutionPreset.high, enableAudio: true);
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }
  void cameraInit() async {
    cameras = await availableCameras();
    CameraDescription? backCamera;
    for (var cameraDescription in cameras) {
      if (cameraDescription.lensDirection == CameraLensDirection.back) {
        backCamera = cameraDescription;
      }
    }

    if (backCamera != null) {
      controller = CameraController(backCamera!, ResolutionPreset.high, enableAudio: true);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("No back camera found");
    }
  }



  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    cameraInit();
  }

  @override
  void dispose() {
    controller.dispose();
    _enableRotation();
    super.dispose();
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    var screenWidth = Get.size.width;
    var screenHeight = Get.size.height;
    if (Get.context!.orientation == Orientation.landscape) {
      width: MediaQuery.of(context).size.width;
      height: MediaQuery.of(context).size.height;

    }

    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(controller)),
          widget.showTopBanner
              ? Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.appBarTitle,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
              : CarouselSlider(
            carouselController: imageCarouselController,
            options: CarouselOptions(
              height: 50,
              viewportFraction: 0.4,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: imageNameList.map((i) {
              return imageRowChild(
                  _currentIndex, imageNameList.indexOf(i));
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.only(top: ResHeight(40)),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Center(
                        child: Image.asset(
                          imagePathList[_currentIndex],
                          fit: BoxFit.contain,
                          height: ResHeight(350),
                          opacity: AlwaysStoppedAnimation(0.5),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        right: ResWidth(10), bottom: ResHeight(64)),
                    child: IconButton(
                        onPressed: () async {
                          DateTime currentPhoneDate = DateTime.now();
                          var location = await determinePosition();
                          print("okayyyyyyyyyyyyyy");
                          controller.setFlashMode(FlashMode.off);
                          print("doneeeeeeeeeeeee");
                          if (!kIsWeb) {
                            try {
                              await controller.setZoomLevel(1);
                              print("actualy gotiy");
                            } catch (e) {
                              print('Failed to set zoom level: $e');
                            }
                          }
                          final XFile file = await controller.takePicture();
                          print('Taken picture path: ${file.path}');

                          Get.to(ImagePreview(file.path, incrementCurrentIndex,
                              addToReturnList));
                          // generateWMImage(context, file.path);
                        },
                        icon: Icon(
                          Icons.camera,
                          size: 50,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
