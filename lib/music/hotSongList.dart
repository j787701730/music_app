import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';
import '../pageLoading.dart';
import '../utils/common.dart';
import 'songList.dart';

class HotSongList extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavouriteSongsList;

  HotSongList(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs,this.myFavouriteSongsList);

  @override
  _HotSongListState createState() => _HotSongListState();
}

class _HotSongListState extends State<HotSongList> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hotSongList();
  }

  @override
  bool get wantKeepAlive => true;
  List hotSongList = [];
  List highQualitySongList = [];
  List topMvList = [];
  int count = 0;
  String topid = '4';

  _hotSongList() {
    ajax('/hotSongList?key=579621905&cat=%E5%85%A8%E9%83%A8&limit=100&offset=0', (data) {
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
      appBar: AppBar(
        title: Text('热门歌单'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        children: <Widget>[
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
                              }, widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,widget.myFavouriteSongsList);
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
        ],
      ),
    );
  }
}
