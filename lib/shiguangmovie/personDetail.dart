import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';
import '../pageLoading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail.dart';

class PersonDetail extends StatefulWidget {
  final Map props;

  PersonDetail(this.props);

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCity();
  }

  Map currCity = {"count": '47', "id": '328', "n": "福州", "pinyinFull": "Fuzhou", "pinyinShort": "fz"};
  Map background = {};

  _readCity() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currCity = preferences.get('currCity');

    if (!mounted) return;
    if (currCity != null) {
      setState(() {
        currCity = jsonDecode(currCity);
      });
    }
    _getDetail();
  }

  _getDetail() {
    ajax('https://ticket-api-m.mtime.cn/person/detail.api?personId=${widget.props['id']}&cityId=${currCity['id']}',
        (data) {
      if (!mounted) return;
      setState(() {
        background = data['data']['background'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.props['name']),
      ),
      body: background.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  child: Image.network(background['bigImage']),
                ),
                Container(
                  child: Text(background['address']),
                ),
                Container(
                  child: Text('${background['birthYear']}年${background['birthMonth']}月${background['birthDay']}日'),
                ),
                background['deathYear'] == 0
                    ? Placeholder(
                        fallbackHeight: 0,
                        color: Colors.transparent,
                      )
                    : Container(
                        child: Text(
                            ' - ${background['deathYear']}年${background['deathMonth']}月${background['deathDay']}日'),
                      ),
                Container(
                  child: Text(background['height']),
                ),
                Container(
                  child: Text('${background['nameCn']}(${background['nameEn']})'),
                ),
                Container(
                  child: Text('${background['profession']}'),
                ),
                Container(
                  child: Text('影视数量${background['movieCount']}'),
                ),
                Container(
                  child: Text('${background['content']}'),
                ),
                background['expriences'] == null
                    ? Placeholder(
                        fallbackHeight: 0,
                        color: Colors.transparent,
                      )
                    : Column(
                        children: background['expriences'].map<Widget>((item) {
                          return Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Image.network(
                                    item['img'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Container(
                                  child: Text(item['content']),
                                ),
                                Container(
                                  child: Text(item['title']),
                                ),
                                Container(
                                  child: Text('${item['year']}'),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                background['festivals'] == null
                    ? Placeholder(
                        fallbackHeight: 0,
                        color: Colors.transparent,
                      )
                    : Column(
                        children: background['festivals'].map<Widget>((item) {
                          return Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Image.network(item['img']),
                                ),
                                Container(
                                  child: Text('${item['nameCn']}(${item['nameEn']})'),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                background['images'] == null
                    ? Placeholder(
                        fallbackHeight: 0,
                        color: Colors.transparent,
                      )
                    : Column(
                        children: background['images'].map<Widget>((item) {
                          return Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Image.network(item['image']),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                background['awards'] == null
                    ? Placeholder(
                        fallbackHeight: 0,
                        color: Colors.transparent,
                      )
                    : Column(
                        children: background['awards'].map<Widget>((item) {
                          return Column(
                            children: <Widget>[
                              Column(
                                children: item['nominateAwards'].map<Widget>((nominateAward) {
                                  return Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                          return new MovieDetail({
                                            'title': nominateAward['movieTitle'],
                                            'movieId': nominateAward['movieId']
                                          });
                                        }));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Image.network(nominateAward['image']),
                                          Container(
                                            child: Text('${nominateAward['movieTitle']}'),
                                          ),
                                          Container(
                                            child: Text('${nominateAward['movieTitleEn']}'),
                                          ),
                                          Container(
                                            child: Text('${nominateAward['movieYear']}'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Column(
                                children: item['winAwards'].map<Widget>((winAward) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        winAward['image'] == ''
                                            ? Placeholder(
                                                fallbackHeight: 0,
                                                color: Colors.transparent,
                                              )
                                            : Image.network(winAward['image']),
                                        Container(
                                          child: Text('${winAward['awardName']}'),
                                        ),
                                        Container(
                                          child: Text('${winAward['festivalEventYear']}'),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          );
                        }).toList(),
                      ),
              ],
            ),
    );
  }
}
