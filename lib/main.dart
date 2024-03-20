import "package:flutter/material.dart";
import 'package:jjk_video/screen/home_screen.dart';

void main() {
  runApp(JJK_Video());
}

class JJK_Video extends StatelessWidget {
  const JJK_Video({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
