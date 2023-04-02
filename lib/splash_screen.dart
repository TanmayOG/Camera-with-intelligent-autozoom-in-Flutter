import 'package:flutter/material.dart';
import 'package:gsoc/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Start(),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Text("FocusFinder", style: TextStyle(fontSize: 30)),
            const SizedBox(
              height: 10,
            ),
            LoadingAnimationWidget.fallingDot(color: Colors.black, size: 35),
            const Spacer(
              flex: 2,
            ),
            const Text("Take-home qualification tasks",
                style: TextStyle(fontSize: 15)),
            const Text("Tanmay Jha",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
