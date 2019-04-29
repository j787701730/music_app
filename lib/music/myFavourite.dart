import 'package:flutter/material.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'songList.dart';
import '../rxdart/blocProvider.dart';
import 'dart:convert';

class MyFavourite extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavoriteSongsList;

  MyFavourite(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs, this.myFavoriteSongsList);

  @override
  _MyFavouriteState createState() => _MyFavouriteState();
}

class _MyFavouriteState extends State<MyFavourite> {
  List myFavouriteSongs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFavouriteSongs = widget.myFavouriteSongs;
  }

  _init() {
    final bloc = BlocProvider.of(context);
    bloc.blocMyFavouriteSongs.listen((str) {
      if (str != null) {
        List lis = jsonDecode(str);
        if (myFavouriteSongs.length != lis.length) {
          setState(() {
            myFavouriteSongs = lis;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
            child: Text(
              '收藏歌单',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: widget.myFavoriteSongsList.map<Widget>((item) {
              return Container(
                padding: EdgeInsets.only(bottom: 5, top: 5),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      child: Center(
                        child: Text('${widget.myFavoriteSongsList.indexOf(item) + 1}'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                              return new SongList({
                                'id': '${item['songListId']}',
                                'title': '${item['songListName']}',
                              }, widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                                  widget.myFavoriteSongsList);
                            }));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '${item['songListName']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
//                    Container(
//                      width: 30,
//                      child: InkWell(
//                        onTap: () {
//                          widget.changeFavourite({
//                            'songmid': '${item['songmid']}',
//                            'songname': '${item['songname']}',
//                            'singer': '${item['singer']}',
//                          }, false);
//                        },
//                        child: Icon(
//                          Icons.clear,
//                          color: Color(0xFF31C27C),
//                        ),
//                      ),
//                    )
                  ],
                ),
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
            child: Text(
              '收藏单曲',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: myFavouriteSongs.map<Widget>((item) {
              return Container(
                padding: EdgeInsets.only(bottom: 5, top: 5),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      child: Center(
                        child: Text('${myFavouriteSongs.indexOf(item) + 1}'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: InkWell(
                          onTap: () {
                            widget.getSongUrl([item]);
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
                          widget.changeFavourite(item, false, type: 'single');
                        },
                        child: Icon(
                          Icons.clear,
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
