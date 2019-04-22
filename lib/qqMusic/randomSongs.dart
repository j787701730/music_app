import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';
import '../pageLoading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RandomSongs extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;

  RandomSongs(this.getSongUrl, this.changeFavourite,this.myFavouriteSongs);

  @override
  _RandomSongsState createState() => _RandomSongsState();
}

class _RandomSongsState extends State<RandomSongs> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  @override
  bool get wantKeepAlive => true;

  List songList = [];
  int count = 0;

  _getList() {
    ajax(
        'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8'
        '&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472',
        (data) {
      if (!mounted) return;
      Map obj = jsonDecode(data);
      if (obj['code'] == 0) {
        setState(() {
          songList = obj['songlist'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    count = 0;
    return Scaffold(
      body: songList.isEmpty
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              children: songList.map<Widget>((item) {
                count += 1;
                bool flag = false;
                for (var o in widget.myFavouriteSongs) {
                  if (item['data']['songmid'] == o['songmid']) {
                    flag = true;
                    break;
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
                              widget.getSongUrl({'songmid': '${item['data']['songmid']}',
                                'songname': '${item['data']['songname']}',
                                'singer': '${item['data']['singer'][0]['name']}'});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    '${item['data']['songname']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    item['data']['singer'][0]['name'],
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
                              'songmid': '${item['data']['songmid']}',
                              'songname': '${item['data']['songname']}',
                              'singer': '${item['data']['singer'][0]['name']}',
                            }, !flag);
                          },
                          child: Icon(flag ? Icons.favorite : Icons.favorite_border,color: Color(0xFF31C27C),),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
