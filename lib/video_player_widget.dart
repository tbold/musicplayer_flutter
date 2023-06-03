import 'package:assets_audio_player/assets_audio_player.dart' as audioPlayer;
import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/models/player_state.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:collection/collection.dart';

YoutubeExplode _youtubeExplode = YoutubeExplode();

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late audioPlayer.AssetsAudioPlayer _assetsAudioPlayer;
  late TextEditingController _searchController;
  PlayerState _playerState = StoppedState().nextState;
  String? _currentSongName;
  bool _isFetchingAudio = false;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = audioPlayer.AssetsAudioPlayer.newPlayer();
    _searchController = TextEditingController();
    _searchController.text = "jaOiQmhH838";
  }

  // PlayerState _getCurrentState(audioPlayer.AssetsAudioPlayer player) {
  //   if (player.isPlaying.value) return PlayingState();

  //   if (player.playerState.)
  // }

  void _getAudio() async {
    setState(() {
      _isFetchingAudio = true;
    });
    final StreamManifest manifest = await _youtubeExplode.videos.streamsClient
        .getManifest(_searchController.text);

    List<AudioOnlyStreamInfo> audios = manifest.audioOnly;
    var audio = audios
        .firstWhereOrNull((element) => element.audioCodec.startsWith('mp4'));
    if (audio == null) return;
    try {
      _assetsAudioPlayer.open(
        audioPlayer.Audio.network(audio.url.toString()),
        autoStart: false,
      );
      setState(() {
        _playerState = StoppedState();
      });
    } catch (e) {
      print("something went wrong");
    }

    setState(() {
      _isFetchingAudio = false;
    });
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    _searchController.dispose();
    _youtubeExplode.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('musicplayer home page')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration:
                      InputDecoration(label: Text('Enter a youtube id')),
                  controller: _searchController,
                ),
              ),
              IconButton(
                  onPressed: () async => _getAudio(), icon: Icon(Icons.search))
            ],
          ),
          _isFetchingAudio
              ? CircularProgressIndicator()
              : Text(_currentSongName ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_playerState.nextState.icon),
                onPressed: () async {
                  try {
                    _assetsAudioPlayer.playOrPause();
                    setState(() {
                      _playerState = _playerState.nextState;
                    });
                  } catch (e) {
                    print("something went wrong");
                  }
                },
              ),
              IconButton(
                onPressed: () {
                  _assetsAudioPlayer.stop();
                  setState(() {
                    _playerState = StoppedState().nextState;
                  });
                },
                icon: Icon(Icons.stop),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
