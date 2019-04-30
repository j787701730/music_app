import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';

//import 'dart:convert';
import '../pageLoading.dart';
import '../utils/common.dart';
import 'songList.dart';
import 'mv.dart';
import 'hotSongList.dart';
import 'highQualitySongList.dart';
import 'songListCategory.dart';
import 'toplist.dart';

class Discover extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavouriteSongsList;

  Discover(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs, this.myFavouriteSongsList);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hotSongList();
    _highQualitySongList();
    _topMvList();
  }

  @override
  bool get wantKeepAlive => true;
  List hotSongList = [];
  List highQualitySongList = [];
  List topMvList = [];
  int count = 0;
  String topid = '4';

  _hotSongList() {
    ajax('/hotSongList?key=579621905&cat=%E5%85%A8%E9%83%A8&limit=9&offset=0', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        setState(() {
          hotSongList = data['data'];
        });
      }
    });
  }

  _highQualitySongList() {
    ajax('/highQualitySongList?key=579621905&cat=全部&limit=9', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        setState(() {
          highQualitySongList = data['data']['playlists'];
        });
      }
    });
  }

  _topMvList() {
    ajax('/topMvList?key=579621905&limit=9&offset=0', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        setState(() {
          topMvList = data['data'];
        });
      }
    });
  }

  _chooseTopSong(id) {
    setState(() {
      topid = id;
//      _getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double oneIn3 = (MediaQuery.of(context).size.width - 10) / 3;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(bottom: 10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF31C27C), width: 1))),
            child: Wrap(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: InkWell(
                    child: Center(
                      child: Column(
                        children: <Widget>[Icon(Icons.queue_music), Text('歌单')],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new SongListCategory(widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                            widget.myFavouriteSongsList);
                      }));
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: InkWell(
                    child: Center(
                      child: Column(
                        children: <Widget>[Icon(Icons.equalizer), Text('排行榜')],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new TopList(widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                            widget.myFavouriteSongsList);
                      }));
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          hotSongList.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: Text(
                          '热门歌单',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Container(
                            height: 30,
                            child: Center(
                              child: Text(
                                '更多热门',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                              return new HotSongList(widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                                  widget.myFavouriteSongsList);
                            }));
                          },
                        ),
                      )
                    ],
                  ),
                ),
          hotSongList.isEmpty
              ? PageLoading()
              : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Wrap(
                    children: hotSongList.map<Widget>((item) {
                      return Container(
                        padding: EdgeInsets.only(right: 10, bottom: 10),
                        width: oneIn3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                              return new SongList({
                                'id': '${item['id']}',
                                'title': '${item['title']}',
                              }, widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                                  widget.myFavouriteSongsList);
                            }));
                          },
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                    item['coverImgUrl'],
                                    width: oneIn3 - 10,
                                    height: oneIn3 - 10,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    height: 42,
                                    child: Text(
                                      '${item['title']}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                  right: 5,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        Text(
                                          '${numFormat(item['playCount'])}',
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
          highQualitySongList.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: Text(
                          '精品歌单',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Container(
                            height: 30,
                            child: Center(
                              child: Text(
                                '更多精品',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                              return new HighQualitySongList(widget.getSongUrl, widget.changeFavourite,
                                  widget.myFavouriteSongs, widget.myFavouriteSongsList);
                            }));
                          },
                        ),
                      )
                    ],
                  ),
                ),
          highQualitySongList.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Wrap(
                    children: highQualitySongList.map<Widget>((item) {
                      return Container(
                        padding: EdgeInsets.only(right: 10, bottom: 10),
                        width: oneIn3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                              return new SongList({
                                'id': '${item['id']}',
                                'title': '${item['title']}',
                              }, widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                                  widget.myFavouriteSongsList);
                            }));
                          },
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                    item['coverImgUrl'],
                                    width: oneIn3 - 10,
                                    height: oneIn3 - 10,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    height: 42,
                                    child: Text(
                                      '${item['title']}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
          topMvList.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: Text(
                          '热门MV',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Text(
                            '更多MV',
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                ),
          topMvList.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Wrap(
                    children: topMvList.map<Widget>((item) {
                      return Container(
                        padding: EdgeInsets.only(right: 10, bottom: 10),
                        width: oneIn3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                              return new Mv(
                                {
                                  'id': '${item['id']}',
                                  'title': '${item['name']}',
                                },
                              );
                            }));
                          },
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                    item['pic'],
                                    width: oneIn3 - 10,
                                    height: oneIn3 - 10,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    height: 42,
                                    child: Text(
                                      '${item['name']}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                  right: 5,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        Text(
                                          '${numFormat(item['playCount'])}',
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
