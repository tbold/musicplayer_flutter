class AudioDetail {
  String title;
  String artist;
  String streamUrl;
  Duration? duration;
  String? thumbnailUrl;

  AudioDetail(
      {required this.title,
      required this.artist,
      required this.streamUrl,
      this.duration,
      this.thumbnailUrl});
}
