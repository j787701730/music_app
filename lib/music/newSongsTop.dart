import 'package:flutter/material.dart';
import 'util.dart';
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
    _getList();
  }

  @override
  bool get wantKeepAlive => true;
  List songList = [];
  int count = 0;
  String topid = '4';

  List songListTop = [
    {'topid': '4', 'name': '流行指数榜'},
    {'topid': '26', 'name': '热歌榜榜'},
    {'topid': '27', 'name': '新歌榜'},
    {'topid': '5', 'name': '内地榜'},
    {'topid': '6', 'name': '港台榜'},
    {'topid': '3', 'name': '欧美榜'},
    {'topid': '16', 'name': '韩国榜'},
    {'topid': '17', 'name': '日本榜'},
    {'topid': '59', 'name': '香港本地榜'},
    {'topid': '60', 'name': '抖音排行榜'},
    {'topid': '28', 'name': '网络歌曲榜'},
    {'topid': '57', 'name': '电音榜'},
    {'topid': '29', 'name': '影视金曲榜'},
    {'topid': '52', 'name': '腾讯音乐人原创榜'},
    {'topid': '36', 'name': 'K歌金曲榜'},
    {'topid': '58', 'name': '说唱榜'},
    {'topid': '108', 'name': '美国公告牌榜'},
    {'topid': '106', 'name': '韩国Mnet榜'},
    {'topid': '107', 'name': '英国UK榜'},
    {'topid': '105', 'name': '日本公信榜'},
    {'topid': '114', 'name': '香港商台榜'},
  ];

  _getList() {
    setState(() {
      songList = [];
    });
    ajax(
        'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?uin=0&notice=0'
        '&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=$topid', (data) {
      if (!mounted) return;
      Map obj = jsonDecode(data);
      if (obj['code'] == 0) {
        setState(() {
          songList = obj['songlist'];
        });
      }
    });
  }

  _chooseTopSong(id) {
    setState(() {
      topid = id;
      _getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    count = 0;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only( bottom: 10),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF31C27C),width: 1)
              )
            ),
            child: Wrap(
              children: songListTop.map<Widget>((item) {
                return Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 30,
                  child: InkWell(
                    onTap: () {
                      _chooseTopSong(item['topid']);
                    },
                    child: Center(
                      child: Text(item['name']),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            height: 10,
          ),
          songList.isEmpty
              ? PageLoading()
              : Column(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 30,
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
                                    'songmid': '${item['data']['songmid']}',
                                    'songname': '${item['data']['songname']}',
                                    'singer': '${item['data']['singer'][0]['name']}'
                                  });
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
