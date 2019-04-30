import 'package:flutter/material.dart';
import 'package:music_app/utils/util.dart';
import 'dart:convert';
import '../rxdart/blocProvider.dart';
import 'searchSongPage.dart';

class SearchSongs extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;

  SearchSongs(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs);

  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List type = [
//  音乐搜索:type=song
//  歌手搜索:type=singer
//  专辑搜索:type=album
//  歌单搜索:type=list
//  视频搜索:type=video
//  电台搜索:type=radio
//  用户搜索:type=user
//  歌词搜索:type=lrc
    {'type': 'song', 'name': '歌曲'},
    {'type': 'singer', 'name': '歌手'},
    {'type': 'album', 'name': '专辑'},
    {'type': 'list', 'name': '歌单'},
    {'type': 'video', 'name': '视频'},
    {'type': 'radio', 'name': '电台'},
    {'type': 'user', 'name': '用户'},
    {'type': 'lrc', 'name': '歌词'},
  ];

  List songTypeData = [];
  int tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: type.length);
    _tabController.addListener(() {
      if (_tabController.index.toDouble() == _tabController.animation.value) {
        setState(() {
          tabIndex = _tabController.index;
          _getList();
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
  List songList = [];
  String searchWord = '逆流成河';
  int count = 0;
  TabController _tabController;

//  String type = 'song';
  FocusNode _contentFocusNode = FocusNode();

  @override
  void dispose() {
    _contentFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _getList() {
    _contentFocusNode.unfocus();
    if (searchWord.trim() == '') {
      return;
    }
    ajax('/search?key=579621905&s=$searchWord&type=${type[tabIndex]['type']}&limit=50&offset=0', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        print(data['data']);
        switch (tabIndex) {
          case 0:
            setState(() {
              songTypeData = data['data'];
            });
            break;
        }
      }
    });
  }

  queryChange(val) {
    setState(() {
      searchWord = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = BlocProvider.of(context);
    count = 0;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: TextField(
                    focusNode: _contentFocusNode,
                    controller: TextEditingController.fromValue(TextEditingValue(
                        // 设置内容
                        text: '$searchWord',
                        selection: TextSelection.fromPosition(
                            TextPosition(affinity: TextAffinity.downstream, offset: '$searchWord'.length))
                        // 保持光标在最后
                        )),
                    decoration: InputDecoration(hintText: '搜索歌曲', hintStyle: TextStyle(color: Colors.white)),
                    onChanged: queryChange,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _getList,
              )
            ],
          ),
        ),
        bottom: TabBar(
          isScrollable: true,
          tabs: type.map<Widget>((item) {
            return Tab(
              text: item['name'],
            );
          }).toList(),
          controller: _tabController,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _contentFocusNode.unfocus();
        },
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            SearchSongPage({'data': songTypeData}, widget.getSongUrl),
            new Center(child: new Text('歌手')),
            new Center(child: new Text('专辑')),
            new Center(child: new Text('歌单')),
            new Center(child: new Text('视频')),
            new Center(child: new Text('电台')),
            new Center(child: new Text('用户')),
            new Center(child: new Text('歌词')),
          ],
        ),
      ),
    );
  }
}
