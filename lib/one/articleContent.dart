import 'package:flutter/material.dart';
import '../pageLoading.dart';
import 'util.dart';
import 'dart:convert';
import 'commentWidget.dart';
import 'authorList.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleContent extends StatefulWidget {
  final params;

  ArticleContent(this.params);

  @override
  _ArticleContentState createState() => _ArticleContentState(params);
}

class _ArticleContentState extends State<ArticleContent> {
  final Map params;

  _ArticleContentState(this.params);

  Map article = {};
  Map comments = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArticle();
    _getComment();
  }

  _getArticle() {
    ajax('http://v3.wufazhuce.com:8000/api/essay/${params['item_id']}', (data) {
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          article = data['data'];
        });
      }
    });
  }

  _getComment() {
    ajax('http://v3.wufazhuce.com:8000/api/comment/praiseandtime/essay/${params['item_id']}/0', (data) {
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
      body: article.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  child: Text(
                    article['hp_title'],
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('文 / ${article['author'][0]['user_name']}'),
                ),
                Html(
                  data: article['hp_content'],
                  padding: EdgeInsets.only(left: 20, right: 20),
                  defaultTextStyle: TextStyle(
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text(
                    '${article['hp_author_introduce']} ${article['editor_email']}',
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
                CommentsWidget(comments),
              ],
            ),
    );
  }
}
