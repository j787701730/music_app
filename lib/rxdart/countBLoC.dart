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

  String _str = 'xxxx';
  var _subject2 = BehaviorSubject<String>();

  Stream<String> get strVal => _subject2.stream;

  String get str => _str;

  void send(val) {
    _subject2.add(val);
  }

  void dispose() {
    _subject.close();
    _subject2.close();
  }
}
