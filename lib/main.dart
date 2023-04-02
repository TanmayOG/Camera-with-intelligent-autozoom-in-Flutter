import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:gsoc/splash_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tflite/tflite.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadModel();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    if (kDebugMode) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }
  runApp(const MyApp());
}

loadModel() async {
  await Tflite.loadModel(
    model: "assets/mobilenet_v1_1.0_224.tflite",
    labels: "assets/mobilenet_v1_1.0_224.txt",
  ).then((value) {
    print('Model loaded');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 1,
              ),
              const Text("FocusFinder", style: TextStyle(fontSize: 30)),
              const SizedBox(
                height: 10,
              ),
              LoadingAnimationWidget.fallingDot(color: Colors.black, size: 35),
              const Spacer(
                flex: 1,
              ),
              const Text("Take-home qualification tasks",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const Text("Task: Camera with intelligent autozoom in Flutter",
                  style: TextStyle(fontSize: 15)),
              const SizedBox(
                height: 30,
              ),
              const Text("Description", style: TextStyle(fontSize: 15)),
              const Text(
                  "Write a Flutter app that lets you take pictures of anything and autozooms to the right size to pick up an object that is in view. For example: Take a collection of dogs, or cats (there are probably pretrained models for this, it's up to you to look them up). If your app is used to take a picture of a dog, then the zoom should be automatically adjusted to take a picture of the dog in foreground, even if the dog is a bit far.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15)),
              const Spacer(
                flex: 1,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: MaterialButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () {
                      final picker = ImagePicker();
                      // picker.pickImage(source: ImageSource.camera);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SecondModel(title: 'Second Model')),
                      );
                    },
                    child: const Text("Start"),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ThirdModel(),
              //         ),
              //       );
              //     },
              //     child: const Text('Start'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
