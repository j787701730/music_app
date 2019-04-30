import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../pageLoading.dart';
import 'miniComments.dart';
import 'imageAll.dart';
import 'movieCreditsWithTypes.dart';
import 'video.dart';
import 'mini.dart';
import 'plus.dart';

class MovieDetail extends StatefulWidget {
  final props;

  MovieDetail(this.props);

  @override
  _MovieDetailState createState() => _MovieDetailState(props);
}

class _MovieDetailState extends State<MovieDetail> with AutomaticKeepAliveClientMixin {
  final Map props;

  _MovieDetailState(this.props);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCity();
  }

  Map currCity = {"count": '47', "id": '328', "n": "福州", "pinyinFull": "Fuzhou", "pinyinShort": "fz"};
  Map movies = {};
  Map mini = {};
  Map plus = {};

  _readCity() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currCity = preferences.get('currCity');

    if (!mounted) return;
    if (currCity != null) {
      setState(() {
        currCity = jsonDecode(currCity);
      });
    }
    _getHotPlayMovie();
    _getComment();
  }

  _getComment() {
    ajax('https://ticket-api-m.mtime.cn/movie/hotComment.api?movieId=${props['movieId']}', (data) {
      print('评 论');
      print(jsonEncode(data));
      if (!mounted) return;
      setState(() {
        mini = data['data']['mini'];
        plus = data['data']['plus'];
      });
    });
  }

  _getHotPlayMovie() {
    ajax('https://ticket-api-m.mtime.cn/movie/detail.api?locationId=${currCity['id']}&movieId=${props['movieId']}',
        (data) {
      print(jsonEncode(data));
      if (!mounted) return;
      setState(() {
        movies = data['data'];
      });
    });
  }

  _movieFlag(val) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Text(val),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(props['title']),
      ),
      body: movies.isEmpty
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120,
                      child: Image.network(movies['basic']['img']),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(movies['basic']['name']),
                          ),
                          Container(
                            child: Text(movies['basic']['nameEn']),
                          ),
                          Container(
                            child: Text(movies['basic']['mins']),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                movies['basic']['is3D'] == true
                                    ? _movieFlag('3D')
                                    : Placeholder(
                                        fallbackWidth: 0,
                                        fallbackHeight: 0,
                                        color: Colors.transparent,
                                      ),
                                movies['basic']['isDMAX'] == true
                                    ? _movieFlag('DMAX')
                                    : Placeholder(
                                        fallbackWidth: 0,
                                        fallbackHeight: 0,
                                        color: Colors.transparent,
                                      ),
                                movies['basic']['isIMAX'] == true
                                    ? _movieFlag('IMAX')
                                    : Placeholder(
                                        fallbackWidth: 0,
                                        fallbackHeight: 0,
                                        color: Colors.transparent,
                                      ),
                                movies['basic']['isIMAX3D'] == true
                                    ? _movieFlag('IMAX3D')
                                    : Placeholder(
                                        fallbackWidth: 0,
                                        fallbackHeight: 0,
                                        color: Colors.transparent,
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text('${movies['basic']['type']}'),
                          ),
                          Container(
                            child: Text('${movies['basic']['releaseDate']}${movies['basic']['releaseArea']}上映'),
                          ),
                          Container(
                            child: Text('${movies['basic']['commentSpecial']}'),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('剧情: ${movies['basic']['story']}'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new Video({'title': props['title'], 'movieId': props['movieId']});
                      }));
                    },
                    child: Text('预告${movies['basic']['video']['count']}'),
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(movies['basic']['video']['img']), fit: BoxFit.contain),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new MovieCreditsWithTypes({'title': props['title'], 'movieId': props['movieId']});
                      }));
                    },
                    child: Text('影人'),
                  ),
                ),
                Container(
                  height: 190,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 120,
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              movies['basic']['director']['img'],
                              height: 140,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  movies['basic']['director']['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Text('导演'),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: movies['basic']['actors'].map<Widget>((item) {
                          return Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 120,
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  item['img'],
                                  height: 140,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  child: Center(
                                    child: Text(
                                      item['name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text(
                                      item['nameEn'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text(
                                      '饰:${item['roleName']}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new ImageAll({'title': props['title'], 'movieId': props['movieId']});
                      }));
                    },
                    child: Text('剧照 ${movies['basic']['stageImg']['count']}张'),
                  ),
                ),
                Container(
                  height: 190,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: movies['basic']['stageImg']['list'].map<Widget>((item) {
                      double leftVal = movies['basic']['stageImg']['list'].indexOf(item) == 0 ? 0 : 10;
                      return Container(
                        padding: EdgeInsets.only(left: leftVal),
                        child: Image.network(
                          item['imgUrl'],
                          height: 190,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('${movies['boxOffice']['todayBoxDesUnit']}: ${movies['boxOffice']['todayBoxDes']}'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('${movies['boxOffice']['totalBoxUnit']}: ${movies['boxOffice']['totalBoxDes']}'),
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new Mini({'title': props['title'], 'movieId': props['movieId']});
                      }));
                    },
                    child: Text('短评'),
                  ),
                ),
                MiniComments(mini),
                Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return new Plus({'title': props['title'], 'movieId': props['movieId']});
                      }));
                    },
                    child: Text('精评'),
                  ),
                ),
                MiniComments(plus)
              ],
            ),
    );
  }
}
