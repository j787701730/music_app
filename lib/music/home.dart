import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';
import 'discover.dart';
import 'searchSongs.dart';
import 'myFavourite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'player.dart';
import 'playList.dart';

class MusicHome extends StatefulWidget {
  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> with SingleTickerProviderStateMixin {
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
    _tabController = new TabController(vsync: this, initialIndex: 1, length: categoryList.length);
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
    {'categoryId': '0', 'name': '我的'},
    {'categoryId': '1', 'name': '发现'},
  ];

  getSongUrl(songData, {autoPlay: true}) {
    setState(() {
      playUrl = songData[0]['url'];
      currPlaySong = songData[0];
      autoPlayBool = autoPlay;
    });
    if (songData.length == 1) {
      if (myPlaySongsList.length == 0) {
        changePlayList(songData[0], true);
      } else {
        for (var o in myPlaySongsList) {
          if (o['id'] == songData[0]['id']) {
            break;
          }
          if (myPlaySongsList.indexOf(o) == myPlaySongsList.length - 1) {
            changePlayList(songData[0], true);
          }
        }
      }
    } else {
      changePlayList(songData, true, replace: true);
    }
    saveCurrPlaySong(songData[0]);
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
  /// list 数据  flag true=>添加 false=>删除,
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
          if (o['id'] == list['id']) {
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

  changePlayList(list, bool flag, {replace = false}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String myPlaySongsListStr = preferences.getString('myPlaySongsList');
    List arr = [];
    if (replace) {
      arr = list;
    } else {
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
            if (o['id'] == list['id']) {
              arr.remove(o);
              break;
            }
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
        getSongUrl([currPlaySong], autoPlay: false);
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
          indicatorColor: Colors.transparent,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 14),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                  return new SearchSongs(getSongUrl, changeFavourite, myFavouriteSongs);
                }));
              })
        ],
      ),
      body: WillPopScope(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 400 - 56 - MediaQuery.of(context).padding.top,
                  child: TabBarView(controller: _tabController, children: <Widget>[
                    MyFavourite(getSongUrl, changeFavourite, myFavouriteSongs),
                    Discover(getSongUrl, changeFavourite, myFavouriteSongs),
                  ]),
                ),
                Container(
                    height: 400,
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
          }),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.blue,
            ),
            Text('待')
          ],
        ),
      ),
    );
  }
}
