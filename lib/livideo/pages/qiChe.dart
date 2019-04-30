import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';

class QiChe extends StatefulWidget {
  @override
  _QiCheState createState() => _QiCheState();
}

class _QiCheState extends State<QiChe> with AutomaticKeepAliveClientMixin {
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
    ajax('http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=31&hotPageidx=1', (data) {
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
