import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/models/audio_detail.dart';

class AudioDetailWidget extends StatelessWidget {
  final AudioDetail? audioDetail;

  const AudioDetailWidget({required this.audioDetail, super.key});

  String calculateDuration() {
    if (audioDetail?.duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes =
          twoDigits(audioDetail!.duration!.inMinutes.remainder(60));
      String twoDigitSeconds =
          twoDigits(audioDetail!.duration!.inSeconds.remainder(60));
      int hours = audioDetail!.duration!.inHours;
      if (hours != 0) {
        return "${twoDigits(hours)}:$twoDigitMinutes:$twoDigitSeconds";
      }
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return audioDetail == null
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              audioDetail!.thumbnailUrl != null
                  ? Image.network(audioDetail!.thumbnailUrl!, fit: BoxFit.cover)
                  : Container(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Title: ${audioDetail!.title}',
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
                Text(
                  'Artist: ${audioDetail!.artist}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
                Text(
                  'Duration: ${calculateDuration()}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
              ])
            ],
          );
  }
}
