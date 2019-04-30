import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import '../plugin/smartDrawer.dart';
import 'package:flutter_html/flutter_html.dart';

class MeiRiHome extends StatefulWidget {
  @override
  _MeiRiHomeState createState() => _MeiRiHomeState();
}

class _MeiRiHomeState extends State<MeiRiHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArticle('https://interface.meiriyiwen.com/article/today?dev=1');
  }

  Color bg = Color(0xFFFFFFFF);
  Map article = {};
  String year = DateTime.now().year.toString();
  String month = DateTime.now().month > 9 ? '${DateTime.now().month}' : '0${DateTime.now().month}';
  String day = DateTime.now().day > 9 ? DateTime.now().day.toString() : '0${DateTime.now().day}';

  _getArticle(url) {
    setState(() {
      article = {};
    });
    ajax(url, (data) {
//      print(jsonEncode(data));
      if (!mounted) return;
      setState(() {
        article = data['data'];
      });
    });
  }

  _bgChange(color) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 100) / 4,
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              bg = Color(color);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Color(color),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Icon(Color(color) == bg ? Icons.check : null),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('每日一文'),
      ),
      body: article.isEmpty
          ? PageLoading()
          : Container(
              color: bg,
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        article['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE4E4E4)))),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(article['author']),
                    ),
                  ),
                  Html(
                    data: article['content'],
//                    padding: EdgeInsets.only(left: 20, right: 20),
                    defaultTextStyle: TextStyle(
                      height: 1.5,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE4E4E4)))),
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        '全文完 共${article['wc']}字',
                        style: TextStyle(color: Colors.black38),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      endDrawer: SmartDrawer(
        widthPercent: 140 / MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.blue,
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text('背景'),
                                ),
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      _bgChange(0xFFFFFFFF),
                                      _bgChange(0xFFD6EED3),
                                      _bgChange(0xFFDDC69E),
                                      _bgChange(0xFFFBE2E2),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
              title: Column(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                  ),
                  Text(
                    ' 阅读设置',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _getArticle('https://interface.meiriyiwen.com/article/day?dev=1&date=${article['date']['prev']}');
              },
              title: Column(
                children: <Widget>[Icon(Icons.fast_rewind), Text('前一天')],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _getArticle('https://interface.meiriyiwen.com/article/random?dev=1');
              },
              title: Column(
                children: <Widget>[Icon(Icons.all_inclusive), Text('随机')],
              ),
            ),
            article.isNotEmpty && '$year$month$day' == article['date']['curr']
                ? Placeholder(
                    fallbackHeight: 1,
                    color: Colors.transparent,
                  )
                : ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getArticle('https://interface.meiriyiwen.com/article/day?dev=1&date=${article['date']['next']}');
                    },
                    title: Column(
                      children: <Widget>[Icon(Icons.fast_forward), Text('后一天')],
                    ),
                  ),
            article.isNotEmpty && '$year$month$day' == article['date']['curr']
                ? Placeholder(
                    fallbackHeight: 1,
                    color: Colors.transparent,
                  )
                : ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getArticle('https://interface.meiriyiwen.com/article/today?dev=1');
                    },
                    title: Column(
                      children: <Widget>[Icon(Icons.schedule), Text('今日')],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
