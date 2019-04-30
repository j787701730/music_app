import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import 'category.dart';

class ReaderHome extends StatefulWidget {
  @override
  _ReaderHomeState createState() => _ReaderHomeState();
}

class _ReaderHomeState extends State<ReaderHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStatistics();
  }

  Map lists = {};
  Map classification = {
    'male': '男生',
    'female': '女生',
    'picture': '漫画',
    'press': '出版',
  };

  _getStatistics() {
    ajax('http://api.zhuishushenqi.com/cats/lv2/statistics', (data) {
      print(data);
      if (!mounted) return;
      setState(() {
        lists = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分类'),
      ),
      body: lists.isEmpty
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.all(10),
              children: lists.keys.map<Widget>((key) {
                print(lists[key].runtimeType);
                return key == 'ok'
                    ? Placeholder(
                        fallbackHeight: 0,
                        color: Colors.transparent,
                      )
                    : Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  border: BorderDirectional(bottom: BorderSide(color: Color(0xFFF2F2F2)))),
                              child: Text(
                                '${classification[key]}',
                                style: TextStyle(color: Color(0xFF999999)),
                              ),
                            ),
                            Wrap(
                              children: lists[key].map<Widget>((item) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new Category({'gender': key,'major':item['name']});
                                    }));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    width: (MediaQuery.of(context).size.width - 20) / 3,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            item['name'],
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                                          ),
                                          Text(
                                            '${item['bookCount']}',
                                            style: TextStyle(color: Color(0xFFCCCCCC)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      );
              }).toList(),
            ),
    );
  }
}
