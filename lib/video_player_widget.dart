import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer_flutter/models/audio_detail.dart';
import 'package:musicplayer_flutter/models/server_track.dart';
import 'package:musicplayer_flutter/models/player_state.dart';
import 'package:musicplayer_flutter/utils.dart';
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
  late Future<List<ServerTrack>> _playlist;

  Future<List<ServerTrack>> _getAudio() async {
    if (_searchController.text.trim() == '') return [];

    var result =
        await http.get(Utils.playlistById(_searchController.text.trim()));

    if (result.statusCode != 200) return [];
    var body = jsonDecode(result.body) as Map;
    if (body['tracks'] == null) return [];
    List<ServerTrack> playlist =
        (body['tracks'] as List).map((e) => ServerTrack.fromJson(e)).toList();

    return playlist;
  }

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.withId("music");
    _searchController = TextEditingController();
    _searchController.text = Utils.examplePlaylistId;
    _playlist = _getAudio();
  }

  Future<AudioDetail?> _getYoutubeAudio() async {
    late StreamManifest manifest;
    late Video videoDetails;

    try {
      await Future.wait([
        (() async => manifest = await _youtubeExplode.videos.streamsClient
            .getManifest(_searchController.text))(),
        (() async => videoDetails =
            await _youtubeExplode.videos.get(_searchController.text))(),
      ]);
      // _assetsAudioPlayer.open(
      //   Audio.network(audio.url.toString()),
      //   autoStart: false,
      // );
      setState(() {
        _playerState = StoppedState();
      });
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   backgroundColor: Theme.of(context).colorScheme.error,
      //   content: Text(e.toString()),
      // ));
      // _isFetchingAudio = false;
      return null;
    }

    List<AudioOnlyStreamInfo> audios = manifest.audioOnly;
    var audio = audios
        .firstWhereOrNull((element) => element.audioCodec.startsWith('mp4'));
    if (audio == null) return null;
    try {
      return AudioDetail(
          title: videoDetails.title,
          artist: videoDetails.author,
          duration: videoDetails.duration,
          thumbnailUrl: videoDetails.thumbnails.mediumResUrl,
          streamUrl: audio.url.toString());
      // });
    } catch (e) {
      print("something went wrong");
      return null;
    }
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
          child: FutureBuilder<List<ServerTrack>>(
              future: _playlist,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final List<ServerTrack> tracks = snapshot.data!;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  label: Text(
                                'Enter a playlist id',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 16),
                              )),
                              controller: _searchController,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  _playlist = _getAudio();
                                });
                              },
                              icon: Icon(Icons.search))
                        ],
                      ),
                      (snapshot.data == null || snapshot.data!.isEmpty)
                          ? const Center(
                              child: Text('No tracks found'),
                            )
                          : SizedBox(
                              height: 500,
                              width: 500,
                              child: ListView.builder(
                                  itemCount: tracks.length,
                                  itemBuilder: (ctx, idx) {
                                    return ListTile(
                                      title: Text(tracks[idx].trackName),
                                    );
                                  }),
                            ),
                      Expanded(
                        child: Row(
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
                      ),
                    ],
                  );
                }
                return Container();
              }))),
    );
  }
}
