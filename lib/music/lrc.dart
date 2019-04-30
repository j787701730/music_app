import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../rxdart/blocProvider.dart';
import 'dart:convert';
import 'dart:ui';

class Lrc extends StatefulWidget {
  final props;

  Lrc(this.props);

  @override
  _LrcState createState() => _LrcState();
}

class _LrcState extends State<Lrc> {
  Map currSong;
//  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _scrollController = new ScrollController();
    currSong = widget.props['currPlaySong'];
    _lrc();
  }

  @override
  void dispose() {
//    _scrollController.dispose();
    super.dispose();
  }

  Map lrcData;

  _init() {
    final bloc = BlocProvider.of(context);
    bloc.blocCurrPlaySong.listen((str) {
      if (str != null) {
        if (currSong['id'] != jsonDecode(str)['id']) {
          setState(() {
            currSong = jsonDecode(str);
            _lrc();
          });
        }
      }
    });
  }

  _lrc() async {
//    _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
    try {
      Response response;
      response = await Dio().get("${currSong['lrc']}", options: new Options(responseType: ResponseType.plain));
      if (!mounted) return;
      if (response.data != null) {
        var lrc = response.data;
        print(lrc);
        setState(() {
          lrcData = getLyricMap(lrc);
        });
      }
      _init();
    } catch (e) {
      return print(e);
    }
  }

  getLyricMap(lrc) {
    Map<String, String> ret = Map();
    String value, key;
    int sIdx, eIdx, nsIdx;
    advance(n) {
      lrc = lrc.substring(n);
    }

    while (lrc != null) {
      sIdx = lrc.indexOf('[');
      eIdx = lrc.indexOf(']') + 1;
      if (sIdx != -1 && eIdx != -1) {
        key = lrc.substring(sIdx, eIdx);
        advance(eIdx);
        nsIdx = lrc.indexOf('[');
        if (nsIdx != -1) {
          value = lrc.substring(0, nsIdx).trim();
          ret.addAll({'$key': '$value'});
          advance(nsIdx);
        }
      } else {
        break;
      }
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: currSong == null ? Text('歌词') : Text('${currSong['name']}'),
        ),
        body: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage(currSong['pic']),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                    Colors.black38,
                    BlendMode.overlay,
                  ),
                ),
              ),
            ),
            new Container(
                child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Opacity(
                opacity: 0.5,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            )),
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56,
              child: Container(
                child: ListView(
//                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                  children: <Widget>[
                    lrcData != null
                        ? Column(
                            children: lrcData.keys.map<Widget>((item) {
                              return lrcData[item] == ''
                                  ? Placeholder(
                                      fallbackHeight: 1,
                                      color: Colors.transparent,
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                      child: Center(
                                        child: Text(
                                          lrcData[item],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                            }).toList(),
                          )
                        : Container(
                            child: Center(
                              child: Text('无歌词'),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
