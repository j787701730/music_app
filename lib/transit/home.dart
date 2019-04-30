import 'package:flutter/material.dart';
import 'util.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class TransitHome extends StatefulWidget {
  @override
  _TransitHomeState createState() => _TransitHomeState();
}

class _TransitHomeState extends State<TransitHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String transitNo = '';
  bool isLoad = false;
  List result = [];

  _getTransit() {
    setState(() {
      isLoad = true;
    });
    ajax('https://way.jd.com/jisuapi/transitLine?city=福州&transitno=$transitNo', (data) {
      print(jsonEncode(data['result']['result']));
      if (!mounted) return;
      if (data['code'] == '10000') {}
      setState(() {
        isLoad = false;
        result = data['result']['result'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公交地铁(福州)'),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 200,
                  child: TextField(
                    controller: TextEditingController.fromValue(TextEditingValue(
                        // 设置内容
                        text: '$transitNo',
                        selection: TextSelection.fromPosition(
                            TextPosition(affinity: TextAffinity.downstream, offset: '$transitNo'.length))
                        // 保持光标在最后
                        )),
                    onChanged: (val) {
                      setState(() {
                        transitNo = val;
                      });
                    },
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (transitNo != '') {
                        _getTransit();
                      }
                    })
              ],
            ),
          ),
          Offstage(
            offstage: !isLoad,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          result.isEmpty
              ? Placeholder(
                  fallbackHeight: 1,
                  color: Colors.transparent,
                )
              : Column(
                  children: result.map<Widget>((item) {
                    return Column(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Text(item['transitno']),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text('方向: ${item['startstation']}'),
                            Icon(Icons.arrow_forward),
                            Text('${item['endstation']}'),
                            Text(' 总${item['list'].length}站')
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('时间: ${item['starttime']}'),
                            Icon(Icons.arrow_forward),
                            Text('${item['endtime']}')
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('票价: ${item['price']}'),
                            Icon(Icons.arrow_forward),
                            Text('${item['maxprice']}')
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Column(
                          children: item['list'].map<Widget>((list) {
                            String sequenceno = '';
                            if (item['list'].indexOf(list) == 0) {
                              sequenceno = '起';
                            } else if (item['list'].indexOf(list) == item['list'].length - 1) {
                              sequenceno = '终';
                            } else {
                              sequenceno = '${list['sequenceno']}';
                            }

                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue, borderRadius: BorderRadius.all(Radius.circular(30))),
                                      child: Center(
                                        child: Text(
                                          sequenceno,
                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('${list['station']}'),
                                      ),
                                    ),
                                  ],
                                ),
                                item['list'].indexOf(list) == item['list'].length - 1
                                    ? Placeholder(
                                        fallbackHeight: 1,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        height: 20,
                                        margin: EdgeInsets.only(left: 14),
                                        decoration: BoxDecoration(
                                            border: Border(left: BorderSide(color: Colors.black38, width: 2))),
                                      )
                              ],
                            );
                          }).toList(),
                        )
                      ],
                    );
                  }).toList(),
                )
        ],
      ),
    );
  }
}
