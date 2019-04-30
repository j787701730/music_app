import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';

//import 'movieContent.dart';
import 'movieInfo.dart';
import 'drawStars.dart';

class MovieHome extends StatefulWidget {
  @override
  _MovieHomeState createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMovies();
  }

  int start = 0; // 从第几条
  int page = 0;
  int count = 10; // 一次取几条
  int total = 0;
  String city = '福州';
  List subjects = [];

  _getMovies() {
    setState(() {
      subjects = [];
    });
    ajax('https://api.douban.com/v2/movie/in_theaters?city=$city&start=$start&count=$count', (data) {
      if (!mounted) return;
      setState(() {
        subjects = data['subjects'];
        total = data['total'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('电影'),
      ),
      body: SafeArea(
          child: subjects.isEmpty
              ? PageLoading()
              : ListView(
                  children: <Widget>[
                    Column(
                      children: subjects.map<Widget>((item) {
                        String roleTmp = '';
                        if (item['directors'] != null) {
                          for (var director in item['directors']) {
                            if (item['directors'].indexOf(director) == 0) {
                              roleTmp += ' ${director['name']}(导演)';
                            } else {
                              roleTmp += ' / ${director['name']}(导演)';
                            }
                          }
                        }

                        if (item['casts'] != null) {
                          for (var cast in item['casts']) {
                            if (item['casts'].indexOf(cast) == item['casts'].length - 1) {
                              roleTmp += ' / ${cast['name']}(演员) / ';
                            } else {
                              roleTmp += ' / ${cast['name']}(演员)';
                            }
                          }
                        }

                        if (item['pubdates'] != null) {
                          for (var pubdate in item['pubdates']) {
                            if (item['pubdates'].indexOf(pubdate) == item['pubdates'].length - 1) {
                              roleTmp += '$pubdate(上映)';
                            } else {
                              roleTmp += '$pubdate(上映) / ';
                            }
                          }
                        }

                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new MovieInfo('${item['id']}', item['title']);
                                    }));
                                  },
                                  child: Image.network(
                                    item['images']['small'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text('${item['title']} (${item['original_title']})'),
                                      ),
                                      Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            DrawStars('${item['rating']['stars']}'),
                                            Text('${item['rating']['average']}'),
                                            Text(
                                              '  ${item['collect_count']}人评价',
                                              style: TextStyle(color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '${item['durations']} ${item['genres']} $roleTmp',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          subtitle: Container(
                            padding: EdgeInsets.only(top: 8),
                            height: 190,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Row(
                                  children: item['directors'].map<Widget>((director) {
                                    return InkWell(
                                      onTap: () {
//                                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
//                                              return new MovieContent('${director['alt']}', director['name']);
//                                            }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Column(
                                          children: <Widget>[
                                            Image.network(
                                              '${director['avatars']['small']}',
                                              height: 140,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            Text(director['name']),
                                            Text('导演')
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: item['casts'].map<Widget>((cast) {
                                    return InkWell(
                                      onTap: () {
//                                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
//                                              return new MovieContent('${cast['alt']}', cast['name']);
//                                            }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Column(
                                          children: <Widget>[
                                            Image.network(
                                              '${cast['avatars']['small']}',
                                              height: 140,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            Text(cast['name']),
                                            Text('演员')
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Offstage(
                            offstage: page == 0 ? true : false,
                            child: RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text('上一页'),
                              onPressed: () {
                                setState(() {
                                  page -= 1;
                                  start = page * count;
                                  _getMovies();
                                });
                              },
                            ),
                          ),
                          Offstage(
                            offstage: (page == 0 || total / count - 1 < page) ? true : false,
                            child: Container(
                              width: 10,
                            ),
                          ),
                          Offstage(
                            offstage: total / count - 1 < page ? true : false,
                            child: RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text('下一页'),
                              onPressed: () {
                                setState(() {
                                  page += 1;
                                  start = page * count;
                                  _getMovies();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
    );
  }
}
