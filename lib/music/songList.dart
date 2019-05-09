import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';
import 'dart:convert';
import '../pageLoading.dart';
import '../utils/common.dart';
import 'dart:ui';
import '../rxdart/blocProvider.dart';

class SongList extends StatefulWidget {
  final props;
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavouriteSongsList;

  SongList(this.props, this.getSongUrl, this.changeFavourite, this.myFavouriteSongs, this.myFavouriteSongsList);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> with AutomaticKeepAliveClientMixin {
  List myFavouriteSongs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFavouriteSongs = widget.myFavouriteSongs;
    _songList();
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
  bool get wantKeepAlive => true;
  Map songList = {};
  bool favouriteFlag = false;

  _songList() {
    ajax('/songList?key=579621905&id=${widget.props['id']}', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        if (widget.myFavouriteSongsList.isNotEmpty) {
          for (var o in widget.myFavouriteSongsList) {
            if (o['songListId'] == widget.props['id']) {
              setState(() {
                favouriteFlag = true;
              });
              break;
            }
          }
        }
        setState(() {
          songList = data['data'];
        });
        _init();
      }
    });
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        centerTitle: true,
        //标题居中
        expandedHeight: 200.0,
        //展开高度200
        floating: false,
        //不随着滑动隐藏标题
        pinned: true,
        title: Container(
          child: Text('${widget.props['title']}'),
        ),
        //固定在顶部
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background: songList.isNotEmpty
              ? Stack(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(songList['songListPic']),
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
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
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
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 100,
                              height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Image.network(songList['songListPic']),
                                  Positioned(
                                    right: 5,
                                    top: 5,
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
                                          '${numFormat(songList['songListPlayCount'])}',
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    songList['songListName'],
                                    style: TextStyle(color: Colors.white),
                                  ),
//                                  Row(
//                                    children: <Widget>[
//                                      Image.network(src)
//                                    ],
//                                  )
                                  Text(
                                    songList['songListDescription'],
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      top: MediaQuery.of(context).padding.top + 56 + 10,
                    ),
                  ],
                )
              : Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    double oneIn3 = (MediaQuery.of(context).size.width - 10) / 3;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: songList.isEmpty
              ? PageLoading()
              : ListView(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: FlatButton(
                              onPressed: () {
                                widget.getSongUrl(songList['songs']);
                              },
                              child: Row(
                                children: <Widget>[Icon(Icons.play_circle_outline), Text(' 播放全部')],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(''),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: FlatButton(
                              onPressed: () {
                                Map list = jsonDecode(jsonEncode(songList));
                                list.remove('songs');
                                widget.changeFavourite(list, !favouriteFlag, type: 'list');
                                setState(() {
                                  favouriteFlag = !favouriteFlag;
                                });
                              },
                              child: Text('收藏'),
                              color: favouriteFlag ? Colors.red : Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: songList['songs'].map<Widget>((song) {
                        bool flag = false;
                        if (myFavouriteSongs.isNotEmpty) {
                          for (var o in myFavouriteSongs) {
                            if (o['id'] == song['id']) {
                              flag = true;
                              break;
                            }
                          }
                        }
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                          leading: Container(
                            width: 34,
                            child: Center(
                              child: Text('${songList['songs'].indexOf(song) + 1}'),
                            ),
                          ),
                          title: Text(song['name']),
                          subtitle: Text(song['singer']),
                          trailing: IconButton(
                              icon: flag ? Icon(Icons.remove) : Icon(Icons.add),
                              onPressed: () {
                                widget.changeFavourite(song, !flag, type: 'single');
                              }),
                          onTap: () {
                            widget.getSongUrl([song]);
                          },
                        );
                      }).toList(),
                    )
                  ],
                )),
    );
  }
}
