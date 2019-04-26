import 'package:flutter/material.dart';
import '../rxdart/blocProvider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class Player extends StatefulWidget {
  final playUrl;
  final autoPlayBool;
  final currPlaySong;
  final myPlaySongsList;
  final getSongUrl;
  final changePlayList;

  Player(
      this.playUrl, this.autoPlayBool, this.currPlaySong, this.myPlaySongsList, this.getSongUrl, this.changePlayList);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with WidgetsBindingObserver {
  PlaybackState _state;
  StreamSubscription _playbackStateSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
  }

  @override
  void dispose() {
    disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        connect();
        break;
      case AppLifecycleState.paused:
        disconnect();
        break;
      default:
        break;
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('start');
    if (oldWidget.playUrl != widget.playUrl) {
      if (!mounted) return;
//      _stop();
      start();
      if (widget.autoPlayBool) {
      } else {}
    }
  }

  void connect() async {
    await AudioService.connect();
    if (_playbackStateSubscription == null) {
      _playbackStateSubscription = AudioService.playbackStateStream.listen((PlaybackState playbackState) {
        print('playbackState');
        print(playbackState);
        setState(() {
          _state = playbackState;
        });
      });
    }
  }

  void disconnect() {
    if (_playbackStateSubscription != null) {
      _playbackStateSubscription.cancel();
      _playbackStateSubscription = null;
    }
    AudioService.disconnect();
  }

  _playNext() {
    if (widget.myPlaySongsList.length > 0) {
      for (var o in widget.myPlaySongsList) {
        if (o['id'] == widget.currPlaySong['id']) {
          if (widget.myPlaySongsList.indexOf(o) == widget.myPlaySongsList.length - 1) {
            widget.getSongUrl([widget.myPlaySongsList[0]]);
          } else {
            widget.getSongUrl([widget.myPlaySongsList[widget.myPlaySongsList.indexOf(o) + 1]]);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return Container(
      height: 400,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _state?.basicState == BasicPlaybackState.playing
            ? [pauseButton(), stopButton()]
            : _state?.basicState == BasicPlaybackState.paused ? [playButton(), stopButton()] : [audioPlayerButton()],
      ),
    );
  }

  start() {
    AudioService.start(
      backgroundTask: _backgroundAudioPlayerTask,
      resumeOnClick: true,
      androidNotificationChannelName: 'Audio Service Demo',
      notificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
  }

  RaisedButton audioPlayerButton() => startButton('AudioPlayer');

  RaisedButton startButton(String label) => RaisedButton(
        child: Text(label),
        onPressed: start,
      );

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop),
        iconSize: 64.0,
        onPressed: AudioService.stop,
      );
}

void _backgroundAudioPlayerTask() async {
  CustomAudioPlayer player = CustomAudioPlayer();
  AudioServiceBackground.run(
    onStart: player.run,
    onPlay: player.play,
    onPause: player.pause,
    onStop: player.stop,
    onClick: (MediaButton button) => player.playPause(),
  );
}

class CustomAudioPlayer {
  String streamUri = 'https://api.itooi.cn/music/netease/url?id=1359356908&key=579621905';
  AudioPlayer _audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  Map currPlaySong;
  List myPlaySongsList;

  Future<void> run() async {
    MediaItem mediaItem =
        MediaItem(id: 'audio_1', album: 'Sample Album', title: 'Sample Title', artist: 'Sample Artist');

    AudioServiceBackground.setMediaItem(mediaItem);

    var playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.where((state) => state == AudioPlayerState.COMPLETED).listen((state) {
      stop();
      get();
    });

    play();
    await _completer.future;
    playerStateSubscription.cancel();
  }

  get() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String myPlaySongsListStr = preferences.getString('myPlaySongsList');
    print(myPlaySongsListStr);
    if (myPlaySongsListStr == null) {
    } else {
      myPlaySongsList = jsonDecode(myPlaySongsListStr);
      for (var o in myPlaySongsList) {
        if (o['id'] == currPlaySong['id']) {
          if (myPlaySongsList.indexOf(o) == myPlaySongsList.length - 1) {
            currPlaySong = myPlaySongsList[0];
          } else {
            currPlaySong = myPlaySongsList[myPlaySongsList.indexOf(o) + 1];
          }
        }
      }
      await preferences.setString('currPlaySong', jsonEncode(currPlaySong));
//      AudioService.start(
//        backgroundTask: _backgroundAudioPlayerTask,
//        resumeOnClick: true,
//        androidNotificationChannelName: 'Audio Service Demo',
//        notificationColor: 0xFF2196f3,
//        androidNotificationIcon: 'mipmap/ic_launcher',
//      );
      print('print');
      play();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      pause();
    else
      play();
  }

  void play() async {
    // 获取当前播放的歌曲
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currPlaySongStr = preferences.getString('currPlaySong');
    if (currPlaySongStr != null) {
      currPlaySong = jsonDecode(currPlaySongStr);
      _audioPlayer.play(currPlaySong['url']);
      AudioServiceBackground.setState(
        controls: [pauseControl, stopControl],
        basicState: BasicPlaybackState.playing,
      );
    }
  }

  void pause() {
    _audioPlayer.pause();
    AudioServiceBackground.setState(
      controls: [playControl, stopControl],
      basicState: BasicPlaybackState.paused,
    );
  }

  void stop() {
    _audioPlayer.stop();
    AudioServiceBackground.setState(
      controls: [],
      basicState: BasicPlaybackState.stopped,
    );
    _completer.complete();
  }
}
