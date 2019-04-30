import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';

class MeiShi extends StatefulWidget {
  @override
  _MeiShiState createState() => _MeiShiState();
}

class _MeiShiState extends State<MeiShi> with AutomaticKeepAliveClientMixin {
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
    ajax('http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=6&hotPageidx=1', (data) {
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
