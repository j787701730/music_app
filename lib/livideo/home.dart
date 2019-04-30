import 'package:flutter/material.dart';
import 'pages/toutiao.dart';
import 'pages/shehui.dart';
import 'pages/shijie.dart';
import 'pages/caiFu.dart';
import 'pages/yuLe.dart';
import 'pages/shengHuo.dart';
import 'pages/meiShi.dart';
import 'pages/keJi.dart';
import 'pages/tiYu.dart';
import 'pages/xinZhi.dart';
import 'pages/qiChe.dart';
import 'pages/yinYue.dart';

class LiHome extends StatefulWidget {
  @override
  _LiHomeState createState() => _LiHomeState();
}

class _LiHomeState extends State<LiHome> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List categoryList = [
    {'categoryId': '0', 'name': '头条'},
    {'categoryId': '1', 'name': '社会'},
    {'categoryId': '2', 'name': '世界'},
    {'categoryId': '3', 'name': '财富'},
    {'categoryId': '4', 'name': '娱乐'},
    {'categoryId': '5', 'name': '生活'},
    {'categoryId': '6', 'name': '美食'},
    {'categoryId': '8', 'name': '科技'},
    {'categoryId': '9', 'name': '体育'},
    {'categoryId': '10', 'name': '新知'},
    {'categoryId': '31', 'name': '汽车'},
    {'categoryId': '59', 'name': '音乐'}
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: categoryList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          isScrollable: true,
          tabs: categoryList.map<Widget>((item) {
            return (Tab(child: Text(item['name'])));
          }).toList(),
          controller: _tabController,
        ),
      ),
      body: new TabBarView(controller: _tabController, children: <Widget>[
        TouTiao(),
        SheHui(),
        ShiJie(),
        CaiFu(),
        YuLe(),
        ShengHuo(),
        MeiShi(),
        KeJi(),
        TiYu(),
        XinZhi(),
        QiChe(),
        YinYue()
      ]),
    );
  }
}
