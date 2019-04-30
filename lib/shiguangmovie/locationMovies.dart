import 'package:flutter/material.dart';
import 'util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../pageLoading.dart';

class LocationMovies extends StatefulWidget {
  @override
  _LocationMoviesState createState() => _LocationMoviesState();
}

class _LocationMoviesState extends State<LocationMovies> with AutomaticKeepAliveClientMixin {
  @protected
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCity();
  }

  Map currCity = {"count": '47', "id": '328', "n": "福州", "pinyinFull": "Fuzhou", "pinyinShort": "fz"};
  List movies = [];

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
  }

  _getHotPlayMovie() {
    ajax('https://api-m.mtime.cn/Showtime/LocationMovies.api?locationId=${currCity['id']}', (data) {
      print(jsonEncode(data));
      if (!mounted) return;
      setState(() {
        movies = data['ms'];
      });
    });
  }

  _movieFlag(val) {
    return Container(
      margin: EdgeInsets.only(right: 6),
      padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Text(val,
        style: TextStyle(color: Colors.black38),),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
          child: movies.isEmpty
              ? PageLoading()
              : ListView(
                  padding: EdgeInsets.all(10),
                  children: movies.map<Widget>((item) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 120,
                            child: Image.network(
                              item['img'],
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(item['tCn']),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        item['is3D'] == true
                                            ? _movieFlag('3D')
                                            : Placeholder(
                                          fallbackWidth: 0,
                                          fallbackHeight: 0,
                                          color: Colors.transparent,
                                        ),
                                        item['isDMAX'] == true
                                            ? _movieFlag('DMAX')
                                            : Placeholder(
                                          fallbackWidth: 0,
                                          fallbackHeight: 0,
                                          color: Colors.transparent,
                                        ),
                                        item['isIMAX'] == true
                                            ? _movieFlag('IMAX')
                                            : Placeholder(
                                          fallbackWidth: 0,
                                          fallbackHeight: 0,
                                          color: Colors.transparent,
                                        ),
                                        item['isIMAX3D'] == true
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
                                    child: Text(item['movieType']),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[Text('${item['r']}'), Text('分')],
                                    ),
                                  ),
                                  Container(
                                    child: Text('${item['d']}分钟'),
                                  ),
                                  Container(
                                    child: Text('${item['rd']}'),
                                  ),
                                  item['commonSpecial'] != ''
                                      ? Container(
                                          child: Text(item['commonSpecial']),
                                        )
                                      : Placeholder(
                                          fallbackWidth: 0,
                                          fallbackHeight: 0,
                                          color: Colors.transparent,
                                        ),
                                  Container(
                                    child: Text('${item['dN']}'),
                                  ),
                                  Container(
                                    child: Text('${item['aN1']}/${item['aN2']}'),
                                  ),
                                  Container(
                                    child: Text('${item['wantedCount']}人想看'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )),
    );
  }
}
