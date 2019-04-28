import 'package:flutter/material.dart';
import '../rxdart/blocProvider.dart';
import 'dart:convert';

class PlayList extends StatefulWidget {
  final myPlaySongsList;
  final getSongUrl;
  final changePlayList;
  final currPlaySong;

  PlayList(this.myPlaySongsList, this.getSongUrl, this.changePlayList, this.currPlaySong);

  @override
  _PlayListState createState() => _PlayListState(myPlaySongsList, getSongUrl, changePlayList, currPlaySong);
}

class _PlayListState extends State<PlayList> {
  var myPlaySongsList;
  final getSongUrl;
  final changePlayList;
  var currPlaySong;

  _PlayListState(this.myPlaySongsList, this.getSongUrl, this.changePlayList, this.currPlaySong);

  _init() {
    final bloc = BlocProvider.of(context);
    bloc.blocCurrPlaySong.listen((str) {
      if (str != null) {
        setState(() {
          currPlaySong = jsonDecode(str);
        });
      }
    });
    bloc.blocMyPlaySongsList.listen((str) {
      if (str != null) {
        setState(() {
          myPlaySongsList = jsonDecode(str);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      appBar: AppBar(
        title: Text('播放列表'),
      ),
      body: myPlaySongsList == null
          ? Placeholder(
              fallbackHeight: 1,
              color: Colors.transparent,
            )
          : ListView(
              children: <Widget>[
                Column(
                  children: myPlaySongsList.map<Widget>((item) {
                    bool playicon = false;
                    if (currPlaySong['id'] == item['id']) {
                      playicon = true;
                    }
                    return Container(
                      padding: EdgeInsets.only(bottom: 5, top: 5),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            child: Center(
                              child: playicon
                                  ? Icon(
                                      Icons.volume_up,
                                      color: Color(0xFF31C27C),
                                      size: 20,
                                    )
                                  : Text('${myPlaySongsList.indexOf(item) + 1}'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: InkWell(
                                onTap: () {
                                  getSongUrl([item]);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '${item['name']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        item['singer'],
                                        style: TextStyle(color: Color(0xff777777)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 30,
                            child: InkWell(
                              onTap: () {
                                widget.changePlayList(item, false);
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Color(0xFF31C27C),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
    );
  }
}
