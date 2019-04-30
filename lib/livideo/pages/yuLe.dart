import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';

class YuLe extends StatefulWidget {
  @override
  _YuLeState createState() => _YuLeState();
}

class _YuLeState extends State<YuLe> with AutomaticKeepAliveClientMixin {
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
    ajax('http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=4&hotPageidx=1', (data) {
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
