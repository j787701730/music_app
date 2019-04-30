import 'package:flutter/material.dart';
import 'dart:convert';
import 'util.dart';
import '../pageLoading.dart';
import 'carDetail.dart';

class SeriesName extends StatefulWidget {
  final params;

  SeriesName(this.params);

  @override
  _SeriesNameState createState() => _SeriesNameState(params);
}

class _SeriesNameState extends State<SeriesName> {
  final params;

  _SeriesNameState(this.params);

  List result = [];
  String msg = '';
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMsg();
  }

  _getMsg() {
    setState(() {
      isLoading = true;
    });
    ajax('http://apicloud.mob.com/car/seriesname/query?name=${params['name']}', (data) {
      print(data);
      if (!mounted) return;
      var obj = jsonDecode(data);
      if (obj['retCode'] == '200') {
        setState(() {
          result = obj['result'];
          msg = obj['msg'];
          isLoading = false;
        });
      } else {
        setState(() {
          result = [];
          msg = obj['msg'];
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${params['name']}'),
      ),
      body: isLoading
          ? PageLoading()
          : result.isEmpty
              ? Container(
                  child: Center(
                    child: Text('$msg'),
                  ),
                )
              : ListView(
                  children: result.map<Widget>((item) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                            return new CarDetail({
                              'brandName': '${item['brandName']}',
                              'seriesName': '${item['seriesName']}',
                              'cid': item['carId']
                            });
                          }));
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(item['brandName']),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(item['seriesName']),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(item['guidePrice']),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
