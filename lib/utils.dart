class Utils {
  static String get _serverBaseUrl => "https://openwhyd.org";
  static Uri playlistById(String id) =>
      Uri.parse("$_serverBaseUrl$id?format=json");
  static String get examplePlaylistId => "/hot/electro";
}
