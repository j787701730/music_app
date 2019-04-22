import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';

class SearchSongs extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;

  SearchSongs(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs);

  @override
  _SearchSongsState createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  List songList = [];
  String searchWord = '';
  int count = 0;

  _getList() {
    if (searchWord.trim() == '') {
      setState(() {
        songList = [];
      });
      return;
    }
    ajax('https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=1&n=50&w=$searchWord', (data) {
      if (!mounted) return;
      Map obj = jsonDecode(data.substring(9, data.length - 1));
      if (obj['code'] == 0) {
        setState(() {
          songList = obj['data']['song']['list'];
        });
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
    count = 0;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜索歌曲',
                      ),
                      onChanged: queryChange,
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
          songList.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  fallbackWidth: 1,
                  color: Colors.transparent,
                )
              : Column(
                  children: songList.map<Widget>((item) {
                    count += 1;
                    bool flag = false;
                    if (item != null) {
                      for (var o in widget.myFavouriteSongs) {
                        if (item['songmid'] == o['songmid']) {
                          flag = true;
                          break;
                        }
                      }
                    }
                    return Container(
                      padding: EdgeInsets.only(bottom: 5,top: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xffeeeeee),width: 1)
                        )
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            child: Center(
                              child: Text('$count'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: InkWell(
                                onTap: () {
                                  widget.getSongUrl({
                                    'songmid': '${item['songmid']}',
                                    'songname': '${item['songname']}',
                                    'singer': '${item['singer'][0]['name']}'
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '${item['songname']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        item['singer'][0]['name'],
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
                                widget.changeFavourite({
                                  'songmid': '${item['songmid']}',
                                  'songname': '${item['songname']}',
                                  'singer': '${item['singer'][0]['name']}',
                                }, !flag);
                              },
                              child: Icon(
                                flag ? Icons.favorite : Icons.favorite_border,
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
