import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';
import '../rxdart/blocProvider.dart';
import 'playList.dart';
import 'lrc.dart';

enum PlayerState { stopped, playing, paused }

class Player extends StatefulWidget {
  final playUrl;
  final autoPlayBool;
  final currPlaySong;
  final myPlaySongsList;
  final getSongUrl;
  final changePlayList;

  Player(this.playUrl, this.autoPlayBool, this.currPlaySong, this.myPlaySongsList, this.getSongUrl, this.changePlayList);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '00:00:00';

  get positionText => position != null ? position.toString().split('.').first : '00:00:00';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  double slider = 0.0;
  double maxSlider = 100.0;
  int xx = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
  }

  _initxx() {
    final bloc = BlocProvider.of(context);
    bloc.state.listen((str) {
//      print(str);
//      if(str == 10){
//        _pause();
//      }
    });
  }

  @override
  void dispose() {
    print('dispose');
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playUrl != widget.playUrl) {
      if (!mounted) return;
      stop();
      if (widget.autoPlayBool) {
        setState(() {
          _initAudioPlayer();
          play();
        });
      } else {
        setState(() {
          _initAudioPlayer();
        });
      }
//      _initxx();
    }
  }

  setMaxSlider() {
    List arr = durationText.split(':');
    setState(() {
      maxSlider = double.parse(arr[0]) * 24 * 60 + double.parse(arr[1]) * 60 + double.parse(arr.last);
    });
//    final bloc = BlocProvider.of(context);
//    bloc.send('$maxSlider');
  }

  setSlider() {
    List arr = positionText.split(':');
    setState(() {
      slider = double.parse(arr[0]) * 24 * 60 + double.parse(arr[1]) * 60 + double.parse(arr.last);
    });
//    final bloc = BlocProvider.of(context);
//    bloc.increment(slider.floor());
  }

  _playNext() {
    if (widget.myPlaySongsList.length > 0) {
      for (var o in widget.myPlaySongsList) {
        if (o['id'] == widget.currPlaySong['id']) {
          if (widget.myPlaySongsList.indexOf(o) == widget.myPlaySongsList.length - 1) {
            widget.getSongUrl([widget.myPlaySongsList[0]]);
          } else {
            widget.getSongUrl([widget.myPlaySongsList[widget.myPlaySongsList.indexOf(o) + 1]]);
            break;
          }
        }
      }
    }
  }

  void _initAudioPlayer() {
    _positionSubscription = audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          position = p;
          setSlider();
        }));
    _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() {
          duration = audioPlayer.duration;
          setMaxSlider();
        });
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      } else if (s == AudioPlayerState.COMPLETED) {
        onComplete();
        _playNext();
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
      _playNext();
    });
  }

  Future play() async {
    await audioPlayer.play(widget.playUrl);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  _seek(val) {
    this.setState(() {
      slider = val;
      audioPlayer.seek(val);
    });
  }

  @override
  Widget build(BuildContext context) {
//    final bloc = BlocProvider.of(context);
    return widget.currPlaySong == null
        ? Placeholder(
            fallbackHeight: 1,
            color: Colors.transparent,
          )
        : Container(
            height: 40,
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.2))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: Center(
                      child: Image.network(
                        widget.currPlaySong['pic'],
                        width: 30,
                        height: 30,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return Lrc({'currPlaySong': widget.currPlaySong});
                      }));
                    },
                  ),
                ),
//            StreamBuilder<int>(
//                stream: bloc.stream,
//                initialData: bloc.value,
//                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
//                  return Text(
//                    '${snapshot.data} / ',
//                  );
//                }),
//            StreamBuilder<String>(
//                stream: bloc.strVal,
//                initialData: bloc.str,
//                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                  return Text(
//                    '${snapshot.data}',
//                  );
//                }),
                Container(
                  width: 40,
                  child: Center(
                    child: InkWell(
                      onTap: () => isPlaying ? pause() : play(),
                      child: isPlaying
                          ? Icon(
                              Icons.pause,
                              color: Color(0xFF31C27C),
                            )
                          : Icon(
                              Icons.play_arrow,
                              color: Color(0xFF31C27C),
                            ),
                    ),
                  ),
                ),
//                      IconButton(
//                          onPressed: _isPlaying || _isPaused ? () => _stop() : null,
//                          iconSize: 30,
//                          icon: new Icon(Icons.stop),
//                          color: Colors.cyan),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 14),
                                child: Text(
                                  '${widget.currPlaySong == null ? '' : widget.currPlaySong['name']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            Container(
                              width: 115,
                              padding: EdgeInsets.only(right: 14),
                              child: Text(
                                position != null
                                    ? '${positionText.substring(2) ?? ''} / ${durationText != null ? durationText.length == 8 ? durationText.substring(3) : durationText.substring(2) : ''}'
                                    : duration != null ? durationText : '',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 20,
                          child: Slider(
                            value: slider > 0 ? slider : 0.0,
                            max: maxSlider > 0 ? maxSlider : 100.0,
                            min: 0.0,
                            activeColor: Color(0xFF31C27C),
                            onChanged: (double val) {
                              _seek(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  child: Center(
                    child: InkWell(
                        child: Icon(
                          Icons.playlist_play,
                          color: Color(0xFF31C27C),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                            return PlayList(widget.myPlaySongsList, widget.getSongUrl, widget.changePlayList, widget.currPlaySong);
                          }));
                        }),
                  ),
                ),
              ],
            ));
  }
}
