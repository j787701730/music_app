import 'package:flutter/material.dart';
import 'dart:convert';
import 'util.dart';
import '../pageLoading.dart';
import 'stockDetail.dart';

class StockHome extends StatefulWidget {
  @override
  _StockHomeState createState() => _StockHomeState();
}

class _StockHomeState extends State<StockHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStock();
  }

  Map result = {};

  _getStock() {
    ajax('http://apicloud.mob.com/stock/global/query?', (data) {
      if(!mounted) return;
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
        title: Text('全球股指信息'),
      ),
      body: result.isEmpty
          ? PageLoading()
          : ListView(
              children: result.keys.map<Widget>((key) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '$key',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                      Column(
                        children: result[key].keys.map<Widget>((key2) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Text('$key2'),
                                Column(
                                  children: result[key][key2].map<Widget>((item) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                          return new StockDetail({
                                          'code':'${item['code']}',
                                          'countryName':'${item['name']}',
                                          'continentType':'$key',
                                          });
                                        }));
                                      },
                                      title: Text(item['name']),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
