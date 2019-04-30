import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import 'dart:convert';
import 'categoryContent.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
  }

  Map result = {};

  _getCategory() {
    ajax('http://apicloud.mob.com/tiku/shitiku/category/query?', (data) {
      print(data);
      var res = jsonDecode(data);
      setState(() {
        result = res['result'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('专项题库分类查询'),
      ),
      body: result.isEmpty
          ? PageLoading()
          : ListView(
              children: result.keys.map((k) {
                return Container(
                  padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '$k',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: result[k].map<Widget>((item) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new CategoryContent({'cid': item['cid'], 'title': item['title']});
                              }));
                            },
                            title: Text(item['title']),
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
