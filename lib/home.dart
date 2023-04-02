// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsoc/main.dart';
import 'package:gsoc/picture.dart';
import 'package:tflite/tflite.dart';

class SecondModel extends StatefulWidget {
  const SecondModel({super.key, required this.title});
  final String title;

  @override
  State<SecondModel> createState() => _SecondModelState();
}

class _SecondModelState extends State<SecondModel> {
  CameraImage? img;
  CameraController? controller;
  String output = '';
  double zoomLevel = 1.0; // initial zoom level
  double maxAvailableZoom = 1.0; // maximum zoom level supported by the camera

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    loadCamera();
  }

  loadCamera() {
    controller = CameraController(cameras![0], ResolutionPreset.high);
    controller!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          // maxAvailableZoom = controller!.maxZoomLevel; // get maximum zoom level
          controller!.startImageStream((image) {
            img = image;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    double maxZoomLevel = await controller!.getMaxZoomLevel();
    try {
      if (img != null) {
        int startTime = DateTime.now().millisecondsSinceEpoch;
        await Tflite.runModelOnFrame(
          bytesList: img!.planes.map((plane) {
            return Uint8List.fromList(plane.bytes);
          }).toList(),
          imageHeight: img!.height,
          imageWidth: img!.width,
          numResults: 2,
          asynch: true,
          threshold: 0.1,
          rotation: 90,
        ).then((recognitions) {
          int endTime = DateTime.now().millisecondsSinceEpoch;
          print("Detection took ${endTime - startTime}");
          setState(() {
            output = recognitions![0]['label'];
            if (output == 'Labrador retriever') {
              double newZoomLevel = maxZoomLevel / 2;
              controller!.setZoomLevel(newZoomLevel);
            }
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    ).then((value) {
      print('Model loaded');
    });
  }

  Future takePicture() async {
    setState(() {
      controller!.stopImageStream();
    });

    if (!controller!.value.isInitialized) {
      return null;
    }
    if (controller!.value.isTakingPicture) {
      return null;
    }
    try {
      // await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await controller!.takePicture();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageView(path: picture.path)));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take picture"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // reset zoom level
                zoomLevel = 1.0;
              });
            },
            icon: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 500,
                  width: 500,
                  child: controller == null
                      ? Container()
                      : CameraPreview(controller!),
                ),
              ),
              Text(
                output == '' ? 'No output' : output,
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: takePicture,
                iconSize: 50,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.circle, color: Colors.black),
              ),
              const Text("Tap to take picture")
            ],
          ),
        ),
      ),
    );
  }
}
