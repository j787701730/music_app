import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CountBLoC {
  int _count = 0;
  var _subject = BehaviorSubject<int>();

  Stream<int> get stream => _subject.stream;

  int get value => _count;

  void increment(val) {
    _subject.add(val);
  }

  String _str = '0.0';
  var _subject2 = BehaviorSubject<String>();

  Stream<String> get strVal => _subject2.stream;

  String get str => _str;

  void send(val) {
    _subject2.add(val);
  }

  String _stateVal;
  var _subjectState = BehaviorSubject<String>();

  Stream<String> get state => _subjectState.stream;

  String get stateVal => _stateVal;

  void changeState(val) {
    _subjectState.add(val);
  }

  String _blocCurrPlaySong;
  var _subjectCurrPlaySong = BehaviorSubject<String>();

  Stream<String> get blocCurrPlaySong => _subjectCurrPlaySong.stream;

  String get blocCurrPlaySongVal => _blocCurrPlaySong;

  void changeBlocCurrPlaySong(val) {
    _subjectCurrPlaySong.add(val);
  }


  String _blocMyPlaySongsList;
  var _subjectMyPlaySongsList = BehaviorSubject<String>();

  Stream<String> get blocMyPlaySongsList => _subjectMyPlaySongsList.stream;

  String get blocMyPlaySongsListVal => _blocMyPlaySongsList;

  void changeBlocMyPlaySongsList(val) {
    _subjectMyPlaySongsList.add(val);
  }

  void dispose() {
    _subject.close();
    _subject2.close();
    _subjectState.close();
    _subjectCurrPlaySong.close();
    _subjectMyPlaySongsList.close();
  }
}
