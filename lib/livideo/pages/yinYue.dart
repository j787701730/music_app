import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';

class YinYue extends StatefulWidget {
  @override
  _YinYueState createState() => _YinYueState();
}

class _YinYueState extends State<YinYue> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  Map dataList = {};

  _getList() {
    ajax('http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=59&hotPageidx=1', (data) {
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
