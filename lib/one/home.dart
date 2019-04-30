import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';
import '../pageLoading.dart';
import 'articleContent.dart';
import 'musicContent.dart';
import 'movieContent.dart';
import 'questionContent.dart';
import 'serialContent.dart';

class OneHome extends StatefulWidget {
  @override
  _OneHomeState createState() => _OneHomeState();
}

class _OneHomeState extends State<OneHome> {
  String mp3 = 'http://www.ytmp3.cn/down/58464.mp3';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getidlist();
  }

//  _getMusiclist() {
//    ajax('http://v3.wufazhuce.com:8000/api/channel/music/more/0', (data) {
//      print(jsonEncode(data));
//    });
//  }
  List idList = [];
  Map oneList = {};
  String oneListID = '';
  DateTime date;

  _getidlist() {
    ajax('http://v3.wufazhuce.com:8000/api/onelist/idlist/', (data) {
      if (!mounted) return;
      if (data['res'] == 0) {
        List<int> arr = [];
        for (String o in data['data']) {
          arr.add(int.parse(o));
        }
        arr.sort((a, b) => b.compareTo(a));
        setState(() {
          idList = arr;
          oneListID = '${idList[0]}';
          _getonelist();
        });
      }
    });
  }

  _getonelist() {
    ajax('http://v3.wufazhuce.com:8000/api/onelist/$oneListID/0', (data) {
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          oneList = data['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ONE'),
      ),
      body: oneList.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
//                      Text(oneList['weather']['date']),
                      PopupMenuButton(
                        onSelected: (val) {
                          setState(() {
                            oneListID = val;
                            _getonelist();
                          });
                        },
                        offset: Offset(0, 40),
                        child: Container(
                          child: Row(
                            children: <Widget>[Text(oneList['weather']['date']), Icon(Icons.arrow_drop_down)],
                          ),
                        ),
                        itemBuilder: (BuildContext context) => idList.map<PopupMenuItem>((id) {
                              DateTime time = DateTime.parse(oneList['weather']['date'])
                                  .subtract(Duration(days: idList.indexOf(id)));
                              return new PopupMenuItem(
                                  value: "$id",
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: Text('${time.year}/${time.month}/${time.day}'),
                                        ),
                                      )
                                    ],
                                  ));
                            }).toList(),
                      ),
                      Text('${oneList['weather']['city_name']}·'
                          '${oneList['weather']['climate']}'
                          '${oneList['weather']['temperature']}℃')
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: oneList['content_list'].map<Widget>((list) {
                      switch (list['category']) {
                        case '0':
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
                            title: Column(
                              children: <Widget>[
                                Container(
                                  child: Image.network(
                                    list['img_url'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Center(
                                    child: Text(
                                      '${list['title']} | ${list['pic_info']}',
                                      style: TextStyle(fontSize: 12, color: Colors.black38),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  child: Text(
                                    list['forward'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text(
                                    list['words_info'],
                                    style: TextStyle(fontSize: 12, color: Colors.black38),
                                  ),
                                ),
                                Container(
                                  height: 4,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          );
                          break;
                        case '1':
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new ArticleContent({
                                  'item_id': list['item_id'],
                                  'title': list['title'],
                                  'share_url': list['share_url']
                                });
                              }));
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text('-- ${category[list['category']]} --',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(
                                    '${list['title']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  child: Text('文 / ${list['author']['user_name']}',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Image.network(
                                    list['img_url'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(
                                    list['forward'],
                                    style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.5),
                                  ),
                                ),
                                Container(
                                  height: 4,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          );
                          break;
                        case '2':
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new SerialContent({
                                  'item_id': list['item_id'],
                                  'title': list['title'],
                                  'share_url': list['share_url']
                                });
                              }));
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text('-- ${category[list['category']]} --',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text('${list['title']}', style: TextStyle(fontSize: 18)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  child: Text('文 / ${list['author']['user_name']}',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Image.network(
                                    list['img_url'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    list['forward'],
                                    style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.5),
                                  ),
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                ),
                                Container(
                                  height: 4,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          );
                          break;
                        case '3':
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new QuestionContent({
                                  'item_id': list['item_id'],
                                  'title': list['title'],
                                  'share_url': list['share_url']
                                });
                              }));
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text('-- ${category[list['category']]} --',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text('${list['title']}', style: TextStyle(fontSize: 18)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text('${list['answerer']['user_name']}答',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Image.network(
                                    list['img_url'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    list['forward'],
                                    style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.5),
                                  ),
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                ),
                                Container(
                                  height: 4,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          );
                          break;
                        case '4':
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new MusicContent({
                                  'item_id': list['item_id'],
                                  'title': list['title'],
                                  'share_url': list['share_url']
                                });
                              }));
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text('-- ${category[list['category']]} --',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text('${list['title']}', style: TextStyle(fontSize: 18)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  child: Text('文 / ${list['author']['user_name']}',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 3,
                                    height: MediaQuery.of(context).size.width / 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                            list['img_url'],
                                          )),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width / 3))),
                                      child: Center(
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color: Color.fromRGBO(255, 255, 255, 0.6),
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '${list['music_name']} ·${list['audio_author']} | ${list['audio_album']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                ),
                                Container(
                                  child: Text(
                                    list['forward'],
                                    style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.5),
                                  ),
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                ),
                                Container(
                                  height: 4,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                          );
                          break;
                        case '5':
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new MovieContent({
                                  'item_id': list['item_id'],
                                  'title': list['title'],
                                  'share_url': list['share_url']
                                });
                              }));
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text('-- ${category[list['category']]} --',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text('${list['title']}', style: TextStyle(fontSize: 18)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  child: Text('文 / ${list['author']['user_name']}',
                                      style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  child: Image.network(
                                    list['img_url'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    list['forward'],
                                    style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.5),
                                  ),
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('————《${list['subtitle']}》',
                                          style: TextStyle(fontSize: 14, color: Colors.black38, height: 1.5))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                          break;
                        default:
                          return Placeholder(
                            fallbackHeight: 1,
                            color: Colors.transparent,
                          );
                          break;
                      }
                    }).toList(),
                  ),
                )
              ],
            ),
    );
  }
}
