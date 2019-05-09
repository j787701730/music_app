import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';
import '../pageLoading.dart';
//import '../utils/common.dart';
import 'songList.dart';
//import 'mv.dart';
//import 'hotSongList.dart';

class HighQualitySongList extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavouriteSongsList;

  HighQualitySongList(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs,this.myFavouriteSongsList);

  @override
  _HighQualitySongListState createState() => _HighQualitySongListState();
}

class _HighQualitySongListState extends State<HighQualitySongList> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _highQualitySongList();
  }

  @override
  bool get wantKeepAlive => true;
  List hotSongList = [];
  List highQualitySongList = [];
  List topMvList = [];
  int count = 0;
  String topid = '4';

  _highQualitySongList() {
    ajax('/highQualitySongList?key=579621905&cat=全部&limit=100', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        setState(() {
          highQualitySongList = data['data']['playlists'];
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
        title: Text('精品歌单'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        children: <Widget>[
          highQualitySongList.isEmpty
              ? PageLoading()
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
                                    height: 30,
                                    child: Text(
                                      '${item['title']}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
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
        ],
      ),
    );
  }
}
