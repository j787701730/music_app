import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'chapters.dart';

class BookInfo extends StatefulWidget {
  final Map props;

  BookInfo(this.props);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  Map info = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getbooks();
  }

  _getbooks() {
    ajax('http://api.zhuishushenqi.com/book/${widget.props['id']}', (data) {
      if (!mounted) return;
      setState(() {
        info = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.props['title']} 详情'),
      ),
      body: info.isEmpty
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Image.network(Uri.decodeFull(info['cover']).substring(7)),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(info['title']),
                            ),
                            Container(
                              child: Text('${info['author']} | ${info['minorCate']} | ${info['wordCount']}字'),
                            ),
                            Container(
                              child: Text(
                                  '${TimelineUtil.formatByDateTime(DateTime.tryParse(info['updated']).subtract(Duration(hours: 8)), locale: 'zh', dayFormat: DayFormat.Simple)}更新'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width - 20) / 3,
                      child: Center(
                        child: Column(
                          children: <Widget>[Text('追人气'), Text('${info['latelyFollower']}')],
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 20) / 3,
                      child: Center(
                        child: Column(
                          children: <Widget>[Text('读者留存率'), Text('${info['retentionRatio']}%')],
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 20) / 3,
                      child: Center(
                        child: Column(
                          children: <Widget>[Text('日更字数/天'), Text('${info['serializeWordCount']}')],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(info['longIntro']),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      child: Text('目录'),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                            return new Chapters({'title': info['title'], 'id': info['_id']});
                          }));
                        },
                        child: Text(
                            '${TimelineUtil.formatByDateTime(DateTime.tryParse(info['updated']).subtract(Duration(hours: 8)), locale: 'zh', dayFormat: DayFormat.Simple)}更新 ${info['lastChapter']}'),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
