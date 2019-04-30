import 'package:flutter/material.dart';
import '../util.dart';
import '../otherListView.dart';
import 'dart:convert';

class SheHui extends StatefulWidget {
  @override
  _SheHuiState createState() => _SheHuiState();
}

class _SheHuiState extends State<SheHui> with AutomaticKeepAliveClientMixin{
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
    ajax(
      'http://app.pearvideo.com/clt/jsp/v2/getCategoryConts.jsp?categoryId=1&hotPageidx=1',
        (data) {
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
