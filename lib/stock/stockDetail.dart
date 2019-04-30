import 'package:flutter/material.dart';
import 'dart:convert';
import '../pageLoading.dart';
import 'util.dart';

class StockDetail extends StatefulWidget {
  final params;

  StockDetail(this.params);

  @override
  _StockDetailState createState() => _StockDetailState(params);
}

class _StockDetailState extends State<StockDetail> {
  final params;

  _StockDetailState(this.params);

  Map result = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDetail();
  }

  _getDetail() {
    ajax(
        'http://apicloud.mob.com/stock/global/queryDetail?code=${params['code']}&countryName=${params['countryName']}&continentType=${params['continentType']}',
        (data) {
      if (!mounted) return;
      var obj = jsonDecode(data);
      setState(() {
        result = obj['result'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params['countryName']),
      ),
      body: result.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text('${result['name']}(${result['code']})'),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '行情时间',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text('${result['time']}'),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.only(right: 20),
                        child: Text('涨跌额', textAlign: TextAlign.end),
                      ),
                      Expanded(
                        child: Text('${result['change']}'),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.only(right: 20),
                        child: Text('涨跌幅', textAlign: TextAlign.end),
                      ),
                      Expanded(
                        child: Text('${result['changeRate']}%'),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.only(right: 20),
                        child: Text('最新价', textAlign: TextAlign.end),
                      ),
                      Expanded(
                        child: Text('${result['price']}'),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
