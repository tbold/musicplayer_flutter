import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/models/audio_detail.dart';

class AudioDetailWidget extends StatelessWidget {
  final AudioDetail? audioDetail;

  const AudioDetailWidget({required this.audioDetail, super.key});

  @override
  Widget build(BuildContext context) {
    return audioDetail == null
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${audioDetail!.title}'),
              Text('Artist: ${audioDetail!.artist}'),
              Text('Duration: ${audioDetail!.duration.toString()}')
            ],
          );
  }
}
