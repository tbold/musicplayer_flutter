import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/theme.dart';
import 'package:musicplayer_flutter/video_player_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'musicplayer',
      theme: customTheme(),
      home: VideoPlayerWidget(),
    );
  }
}
