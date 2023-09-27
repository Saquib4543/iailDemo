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
import 'dart:js' as js;
import 'package:damagedetection1/helpers/routeobserver.dart';

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

class _CameraImageUploadState extends State<CameraImageUpload> with RouteAware {
  int _currentIndex = 0;
  CarouselController imageCarouselController = CarouselController();



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
  void startObjectDetection() {
    print("Calling JS function now...");
    js.context.callMethod('startObjectDetection');
  }
  void stopObjectDetection() {
    print("Requesting JS to stop object detection...");
    js.context.callMethod('stopObjectDetection');
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

  void cameraInit() async {
    cameras = await availableCameras();
    CameraDescription? backCamera;
    for (var cameraDescription in cameras) {
      if (cameraDescription.lensDirection == CameraLensDirection.back) {
        backCamera = cameraDescription;
      }
    }

    if (backCamera != null) {
      controller = CameraController(backCamera!, ResolutionPreset.max, enableAudio: true);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        // startObjectDetection();
      });
    } else {
      print("No back camera found");
    }
  }


  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     print("letsseeifitgetsinthelopp");
  //     // Restart object detection when the widget is in focus
  //     startObjectDetection();
  //   }
  // }
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    cameraInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print("didPopNext called");
    // Restart object detection when the widget is back in focus
    startObjectDetection();
  }

  @override
  void didPush() {
    super.didPush();
    print("didPush called");
    // Start object detection when the widget is pushed to the navigator
    startObjectDetection();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    print("didPush next called");
    // Stop object detection when a new route is pushed on top of this
    stopObjectDetection();
  }

  @override
  void dispose() {
    print("disposeis called");
    routeObserver.unsubscribe(this);
    js.context.callMethod('stopAllOperations');
    // stopObjectDetection();
    // Unsubscribe before other disposal logic
    controller.dispose();
    _enableRotation();
    super.dispose();  // Call this last
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
                  // Expanded(
                  //     child: Center(
                  //       child: Image.asset(
                  //         imagePathList[_currentIndex],
                  //         fit: BoxFit.contain,
                  //         height: ResHeight(350),
                  //         opacity: AlwaysStoppedAnimation(0.5),
                  //       ),
                  //     )),
                  Padding(
                    padding: EdgeInsets.only(
                        right: ResWidth(10), bottom: ResHeight(64)),
                    child: IconButton(
                        onPressed: () async {
                          stopObjectDetection();
                          DateTime currentPhoneDate = DateTime.now();
                          var location = await determinePosition();
                          print("okayyyyyyyyyyyyyy");
                          controller.setFlashMode(FlashMode.off);
                          print("doneeeeeeeeeeeee");
                          print("doneeeeeeeeeeeee2222222");
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
