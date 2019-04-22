import 'package:flutter/material.dart';
import 'util.dart';
import 'newSongsTop.dart';
import 'randomSongs.dart';
import 'searchSongs.dart';
import 'myFavourite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'player.dart';
import 'playList.dart';

class QQMusicHome extends StatefulWidget {
  @override
  _QQMusicHomeState createState() => _QQMusicHomeState();
}

class _QQMusicHomeState extends State<QQMusicHome> with SingleTickerProviderStateMixin {
  TabController _tabController;
  DateTime _lastPressedAt;
  String playUrl;
  Map currPlaySong;
  List myFavouriteSongs;
  List myPlaySongsList;
  bool autoPlayBool = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: categoryList.length);
    getFavoriteSongs();
    getMyPlaySongsList();
    getCurrPlaySong();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List result = [];
  List categoryList = [
    {'categoryId': '0', 'name': '榜单'},
    {'categoryId': '1', 'name': '随机'},
    {'categoryId': '2', 'name': '收藏'},
    {'categoryId': '3', 'name': '搜索'},
    {'categoryId': '4', 'name': '列表'},
  ];

  getSongUrl(songData, {autoPlay: true}) {
    String url = 'https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?format=json205361747&platform=yqq'
        '&cid=205361747&songmid=${songData['songmid']}&filename=C400${songData['songmid']}.m4a&guid=126548448';
    ajax(url, (data) {
      if (!mounted) return;
      Map obj = jsonDecode(data);
      String vkey = obj['data']['items'][0]['vkey'];
      setState(() {
        playUrl = 'http://ws.stream.qqmusic.qq.com/C400${songData['songmid']}.m4a?fromtag=0&guid=126548448&vkey=$vkey';
        currPlaySong = songData;
        autoPlayBool = autoPlay;
      });
      if (myPlaySongsList.length == 0) {
        changePlayList(songData, true);
      } else {
        for (var o in myPlaySongsList) {
          if (o['songmid'] == songData['songmid']) {
            break;
          }
          if (myPlaySongsList.indexOf(o) == myPlaySongsList.length - 1) {
            changePlayList(songData, true);
          }
        }
      }
      saveCurrPlaySong(songData);
    });
  }

  getFavoriteSongs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String myFavouriteSongsStr = preferences.getString('myFavouriteSongs');
    if (myFavouriteSongsStr == null) {
      setState(() {
        myFavouriteSongs = [];
      });
    } else {
      setState(() {
        myFavouriteSongs = jsonDecode(myFavouriteSongsStr);
      });
    }
  }

  // 添加或删除 我的收藏
  changeFavourite(Map list, bool flag) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String myFavouriteSongsStr = preferences.getString('myFavouriteSongs');
    List arr = [];
    if (myFavouriteSongsStr == null) {
      if (flag) {
        arr.add(list);
      }
    } else {
      arr = jsonDecode(myFavouriteSongsStr);
      if (flag) {
        arr.insert(0, list);
      } else {
        for (var o in arr) {
          if (o['songmid'] == list['songmid']) {
            arr.remove(o);
            break;
          }
        }
      }
    }
    setState(() {
      myFavouriteSongs = arr;
    });
    preferences.setString('myFavouriteSongs', jsonEncode(arr));
  }

  getMyPlaySongsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String myPlaySongsListStr = preferences.getString('myPlaySongsList');
    if (myPlaySongsListStr == null) {
      setState(() {
        myPlaySongsList = [];
      });
    } else {
      setState(() {
        myPlaySongsList = jsonDecode(myPlaySongsListStr);
      });
    }
  }

  changePlayList(Map list, bool flag) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String myPlaySongsListStr = preferences.getString('myPlaySongsList');
    List arr = [];
    if (myPlaySongsListStr == null) {
      if (flag) {
        arr.add(list);
      }
    } else {
      arr = jsonDecode(myPlaySongsListStr);
      if (flag) {
        arr.insert(0, list);
      } else {
        for (var o in arr) {
          if (o['songmid'] == list['songmid']) {
            arr.remove(o);
            break;
          }
        }
      }
    }
    setState(() {
      myPlaySongsList = arr;
    });
    preferences.setString('myPlaySongsList', jsonEncode(arr));
  }

  // 获取当前播放的歌曲
  getCurrPlaySong() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currPlaySongStr = preferences.getString('currPlaySong');
    if (currPlaySongStr == null) {
    } else {
      setState(() {
        currPlaySong = jsonDecode(currPlaySongStr);
        getSongUrl(currPlaySong, autoPlay: false);
      });
    }
  }

  // 保存当前播放的歌曲
  saveCurrPlaySong(currPlaySong) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('currPlaySong', jsonEncode(currPlaySong));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TabBar(
            labelPadding: EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            isScrollable: true,
            tabs: categoryList.map<Widget>((item) {
              return (Tab(child: Text(item['name'])));
            }).toList(),
            controller: _tabController,
          ),
        ),
        body: WillPopScope(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 40 - 56 - MediaQuery.of(context).padding.top,
                    child: TabBarView(controller: _tabController, children: <Widget>[
                      NewSongsTop(getSongUrl, changeFavourite, myFavouriteSongs),
                      RandomSongs(getSongUrl, changeFavourite, myFavouriteSongs),
                      MyFavourite(getSongUrl, changeFavourite, myFavouriteSongs),
                      SearchSongs(getSongUrl, changeFavourite, myFavouriteSongs),
                      PlayList(myPlaySongsList, getSongUrl, changePlayList, currPlaySong)
                    ]),
                  ),
                  Container(
                      height: 40,
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                      child: Player(playUrl, autoPlayBool, currPlaySong, myPlaySongsList, getSongUrl, changePlayList))
                ],
              ),
            ),
            onWillPop: () async {
              if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
                //两次点击间隔超过1秒则重新计时
                _lastPressedAt = DateTime.now();

                return false;
              }
              return true;
            }));
  }
}
