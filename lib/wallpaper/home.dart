import 'package:flutter/material.dart';
import 'pages/4k.dart';
import 'pages/congWu.dart';
import 'pages/dongMang.dart';
import 'pages/fengJing.dart';
import 'pages/JunShi.dart';
import 'pages/kuXuan.dart';
import 'pages/love.dart';
import 'pages/mingXing.dart';
import 'pages/model.dart';
import 'pages/qiChe.dart';
import 'pages/qingXin.dart';
import 'pages/time.dart';
import 'pages/tiYu.dart';
import 'pages/wenLi.dart';
import 'pages/wenZi.dart';
import 'pages/youXi.dart';

class WallPaperHome extends StatefulWidget {
  @override
  _WallPaperHomeState createState() => _WallPaperHomeState();
}

class _WallPaperHomeState extends State<WallPaperHome> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List categoryList = [
    {'categoryId': '1', 'name': '限时壁纸'},
    {'categoryId': '36', 'name': '4K专区'},
    {'categoryId': '6', 'name': '美女模特'},
    {'categoryId': '30', 'name': '爱情美图'},
    {'categoryId': '9', 'name': '风景大片'},
    {'categoryId': '15', 'name': '小清新'},
    {'categoryId': '26', 'name': '动漫卡通'},
    {'categoryId': '11', 'name': '明星风尚'},
    {'categoryId': '14', 'name': '萌宠动物'},
    {'categoryId': '5', 'name': '游戏壁纸'},
    {'categoryId': '12', 'name': '汽车天下'},
    {'categoryId': '10', 'name': '炫酷时尚'},
    {'categoryId': '22', 'name': '军事天地'},
    {'categoryId': '16', 'name': '劲爆体育'},
    {'categoryId': '32', 'name': '纹理'},
    {'categoryId': '35', 'name': '文字控'},
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
        Time(),
        K4(),
        Model(),
        Love(),
        FengJing(),
        Qingxin(),
        DongMang(),
        MingXing(),
        CongWu(),
        YouXi(),
        QiChe(),
        KuXuan(),
        JunShi(),
        TiYu(),
        WenLi(),
        WenZi()
      ]),
    );
  }
}
