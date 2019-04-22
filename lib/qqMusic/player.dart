import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'playList.dart';

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
  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '--:--:--';

  get _positionText => _position?.toString()?.split('.')?.first ?? '--:--:--';
  double slider = 0.0;
  double maxSlider = 100.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    AudioPlayer.logEnabled = false;
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playUrl != widget.playUrl) {
      if (!mounted) return;
      _stop();
      if (widget.autoPlayBool) {
        setState(() {
          _initAudioPlayer();
          _position = Duration(seconds: 0);
          _play();
        });
      } else {
        setState(() {
          _initAudioPlayer();
          _position = Duration(seconds: 0);
        });
      }
    }
  }

  setMaxSlider() {
    List arr = _durationText.split(':');
    setState(() {
      maxSlider = double.parse(arr[0]) * 24 * 60 + double.parse(arr[1]) * 60 + double.parse(arr.last);
    });
  }

  setSlider() {
    List arr = _positionText.split(':');
    setState(() {
      slider = double.parse(arr[0]) * 24 * 60 + double.parse(arr[1]) * 60 + double.parse(arr.last);
    });
  }

  _playNext() {
    if (widget.myPlaySongsList.length > 0) {
      for (var o in widget.myPlaySongsList) {
        if (o['songmid'] == widget.currPlaySong['songmid']) {
          if (widget.myPlaySongsList.indexOf(o) == widget.myPlaySongsList.length - 1) {
            widget.getSongUrl(widget.myPlaySongsList[0]);
          } else {
            widget.getSongUrl(widget.myPlaySongsList[widget.myPlaySongsList.indexOf(o) + 1]);
          }
        }
      }
    }
  }

  void _initAudioPlayer() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) => setState(() {
          _duration = duration;
          setMaxSlider();
        }));

    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
          setSlider();
        }));

    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((event) {
//      _onComplete();
      setState(() {
        _position = _duration;
      });
      _playNext();
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = new Duration(seconds: 0);
        _position = new Duration(seconds: 0);
      });
      _playNext();
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(widget.playUrl, isLocal: false, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = new Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }

  _seek(val) {
    this.setState(() {
      slider = val;
      _audioPlayer.seek(Duration(seconds: val.floor()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            onPressed: () => _isPlaying ? _pause() : _play(),
            iconSize: 20,
            icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            color: Color(0xFF31C27C)),

//        Offstage(
//          offstage: _isPlaying,
//          child: IconButton(
//              onPressed: _isPlaying ? null : () => _play(),
//              iconSize: 20,
//              icon: new Icon(Icons.play_arrow),
//              color: Colors.cyan),
//        ),
//        Offstage(
//          offstage: !_isPlaying,
//          child: IconButton(
//              onPressed: _isPlaying ? () => _pause() : null, iconSize: 20, icon: Icon(Icons.pause), color: Colors.cyan),
//        ),

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
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          '${widget.currPlaySong == null ? '' : widget.currPlaySong['songname']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Text(
                        _position != null
                            ? '${_positionText.substring(2) ?? ''} / ${_durationText.substring(2) ?? ''}'
                            : _duration != null ? _durationText : '',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Container(
                  height: 20,
                  child: Slider(
                    value: slider,
                    max: maxSlider,
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
        )
      ],
    );
  }
}
