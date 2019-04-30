import 'package:flutter/material.dart';
import '../pageLoading.dart';
import 'util.dart';
import 'dart:convert';
import 'commentWidget.dart';
import 'authorList.dart';
import 'package:flutter_html/flutter_html.dart';

class MovieContent extends StatefulWidget {
  final params;

  MovieContent(this.params);

  @override
  _MovieContentState createState() => _MovieContentState(params);
}

class _MovieContentState extends State<MovieContent> {
  final Map params;

  _MovieContentState(this.params);

  List articles = [];
  Map comments = {};
  Map pics = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPics();
    _getArticle();
    _getComment();
  }

  _getPics() {
    ajax('http://v3.wufazhuce.com:8000/api/movie/detail/${params['item_id']}', (data) {
      print(jsonEncode(data));
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          pics = data['data'];
        });
      }
    });
  }

  _getArticle() {
    ajax('http://v3.wufazhuce.com:8000/api/movie/${params['item_id']}/story/1/0', (data) {
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          articles = data['data']['data'];
        });
      }
    });
  }

  _getComment() {
    ajax('http://v3.wufazhuce.com:8000/api/comment/praiseandtime/movie/${params['item_id']}/0', (data) {
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          comments = data['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params['title']),
      ),
      body: articles.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                pics.isEmpty
                    ? Placeholder(
                        fallbackHeight: 1,
                        color: Colors.transparent,
                      )
                    : Container(
                        child: Image.network(
                          pics['detailcover'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                Column(
                  children: articles.map<Widget>((article) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                          child: Text(
                            article['title'],
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('文 / ${article['user']['user_name']}'),
                        ),
//                NewsDetailsWeb(body: article['hp_content']),
                        Html(
                          data: article['content'],
                          padding: EdgeInsets.only(left: 20, right: 20),
                          defaultTextStyle: TextStyle(
                            height: 1.5,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Text(
                            '${article['charge_edt']} ${article['editor_email']}',
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '作者',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              height: 4,
                              width: 60,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        AuthorList(article),
                      ],
                    );
                  }).toList(),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    '评论列表',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      height: 4,
                      width: 60,
                      color: Colors.black87,
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                CommentsWidget(comments)
              ],
            ),
    );
  }
}
