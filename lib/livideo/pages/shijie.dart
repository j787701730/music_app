import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';

class ShiJie extends StatefulWidget {
  @override
  _ShiJieState createState() => _ShiJieState();
}

class _ShiJieState extends State<ShiJie> with AutomaticKeepAliveClientMixin {
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
    ajax('http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=2&hotPageidx=1', (data) {
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
