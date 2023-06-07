class ServerTrack {
  String elementId;
  String trackName = "";
  String userName = "";

  ServerTrack({required this.elementId});

  factory ServerTrack.fromJson(dynamic instance) {
    return ServerTrack(elementId: instance['eId'] as String)
      ..trackName = instance['name'] == null ? '' : instance['name'] as String
      ..userName = instance['uNm'] == null ? '' : instance['uNm'] as String;
  }
}
