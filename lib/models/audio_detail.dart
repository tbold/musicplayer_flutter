class AudioDetail {
  String title;
  String artist;
  Duration? duration;
  String? thumbnailUrl;

  AudioDetail(
      {required this.title,
      required this.artist,
      this.duration,
      this.thumbnailUrl});
}
