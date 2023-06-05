import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/models/audio_detail.dart';
import 'package:musicplayer_flutter/models/player_state.dart';
import 'package:musicplayer_flutter/widgets/audio_detail.widget.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:collection/collection.dart';

YoutubeExplode _youtubeExplode = YoutubeExplode();

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late AssetsAudioPlayer _assetsAudioPlayer;
  late TextEditingController _searchController;
  PlayerWidgetState _playerState = StoppedState();
  AudioDetail? _audioDetail;
  bool _isFetchingAudio = false;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.withId("music");
    _searchController = TextEditingController();
    _searchController.text = "jaOiQmhH838";
  }

  void _getAudio() async {
    if (_searchController.text.trim() == '') return;
    setState(() {
      _isFetchingAudio = true;
    });

    late StreamManifest manifest;
    late Video videoDetails;

    try {
      await Future.wait([
        (() async => manifest = await _youtubeExplode.videos.streamsClient
            .getManifest(_searchController.text))(),
        (() async => videoDetails =
            await _youtubeExplode.videos.get(_searchController.text))(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(e.toString()),
      ));
      _isFetchingAudio = false;
      return;
    }

    List<AudioOnlyStreamInfo> audios = manifest.audioOnly;
    var audio = audios
        .firstWhereOrNull((element) => element.audioCodec.startsWith('mp4'));
    if (audio == null) return;
    try {
      _assetsAudioPlayer.open(
        Audio.network(audio.url.toString()),
        autoStart: false,
      );
      setState(() {
        _playerState = StoppedState();
        _audioDetail = AudioDetail(
            title: videoDetails.title,
            artist: videoDetails.author,
            duration: videoDetails.duration,
            thumbnailUrl: videoDetails.thumbnails.mediumResUrl);
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
                  decoration: InputDecoration(
                      label: Text(
                    'Enter a youtube id',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 16),
                  )),
                  controller: _searchController,
                ),
              ),
              IconButton(
                  onPressed: () async => _getAudio(), icon: Icon(Icons.search))
            ],
          ),
          const SizedBox(height: 48),
          _isFetchingAudio
              ? CircularProgressIndicator()
              : AudioDetailWidget(audioDetail: _audioDetail),
          const SizedBox(height: 16),
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
                    _playerState = StoppedState();
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
