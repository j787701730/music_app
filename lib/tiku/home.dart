import 'package:flutter/material.dart';
import 'kemu1.dart';
import 'kemu4.dart';
import 'category.dart';

class TiKuHome extends StatefulWidget {
  @override
  _TiKuHomeState createState() => _TiKuHomeState();
}

class _TiKuHomeState extends State<TiKuHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('题库'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                return new KeMu1();
              }));
            },
            title: Text('科目1'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                return new KeMu4();
              }));
            },
            title: Text('科目4'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                return new Category();
              }));
            },
            title: Text('专项题库分类'),
          )
        ],
      ),
    );
  }
}
