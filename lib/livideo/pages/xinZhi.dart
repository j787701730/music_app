import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';

class XinZhi extends StatefulWidget {
  @override
  _XinZhiState createState() => _XinZhiState();
}

class _XinZhiState extends State<XinZhi> with AutomaticKeepAliveClientMixin {
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
    ajax('http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=10&hotPageidx=1', (data) {
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
