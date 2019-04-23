import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';
import 'dart:convert';
import '../pageLoading.dart';

class NewSongsTop extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;

  NewSongsTop(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs);

  @override
  _NewSongsTopState createState() => _NewSongsTopState();
}

class _NewSongsTopState extends State<NewSongsTop> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hotSongList();
  }

  @override
  bool get wantKeepAlive => true;
  List hotSongList = [];
  int count = 0;
  String topid = '4';

  _hotSongList() {
    ajax('https://api.itooi.cn/music/netease/hotSongList?key=579621905&cat=%E5%85%A8%E9%83%A8&limit=9&offset=0',
        (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        setState(() {
          hotSongList = data['data'];
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
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF31C27C), width: 1))),
//            child: Wrap(
//              children: songListTop.map<Widget>((item) {
//                return Container(
//                  width: MediaQuery.of(context).size.width / 3,
//                  height: 30,
//                  child: InkWell(
//                    onTap: () {
//                      _chooseTopSong(item['topid']);
//                    },
//                    child: Center(
//                      child: Text(item['name']),
//                    ),
//                  ),
//                );
//              }).toList(),
//            ),
          ),
          Container(
            height: 10,
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
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image.network(
                                  item['coverImgUrl'],
                                  width: oneIn3 - 10,
                                  height: oneIn3 - 10,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  '${item['title']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
                                        '${item['playCount']}',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
        ],
      ),
    );
  }
}
