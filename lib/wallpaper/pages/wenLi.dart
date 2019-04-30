import 'package:flutter/material.dart';
import '../util.dart';
import '../commonListView.dart';

class WenLi extends StatefulWidget {
  @override
  _WenLiState createState() => _WenLiState();
}

class _WenLiState extends State<WenLi> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  @override
  bool get wantKeepAlive => true;
  Map dataList = {};

  _getList() {
    ajax('http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory&cid=32&start=0&count=20', (data) {
      if (!mounted) return;
      setState(() {
        dataList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CommonListView(dataList),
    );
  }
}
