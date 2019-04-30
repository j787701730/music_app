import 'package:flutter/material.dart';
import 'dart:convert';
import '../pageLoading.dart';
import 'util.dart';
import 'seriesname.dart';

class CarHome extends StatefulWidget {
  @override
  _CarHomeState createState() => _CarHomeState();
}

class _CarHomeState extends State<CarHome> {
  List result = [];
  List resultTemp = [];
  bool loading = true;
  FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCarBrand();
  }

  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  _getCarBrand() {
    ajax('http://apicloud.mob.com/car/brand/query?', (data) {
      if (!mounted) return;
      var obj = jsonDecode(data);
      setState(() {
        result = obj['result'];
        resultTemp = obj['result'];
        loading = false;
      });
    });
  }

  bool offstage = true;
  String filterVal = '';

  _filterResult() {
    _contentFocusNode.unfocus();
    List arr = [];
    if (filterVal == '') {
      setState(() {
        result = resultTemp;
      });
    } else {
      for (Map res in resultTemp) {
        if (res['name'].contains(filterVal) ||
            res['name'].contains(filterVal.toLowerCase()) ||
            res['name'].contains(filterVal.toUpperCase())) {
          arr.add(res);
        } else {
          List sonList = [];
          for (Map son in res['son']) {
            if (son['type'].contains(filterVal) ||
                son['type'].contains(filterVal.toLowerCase()) ||
                son['type'].contains(filterVal.toUpperCase())) {
              sonList.add(son);
            }
          }
          if (sonList.length > 0) {
            arr.add({'name': res['name'], 'son': sonList});
          }
        }
      }
      setState(() {
        result = arr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('汽车品牌'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  offstage = !offstage;
                });
              })
        ],
      ),
      body: loading
          ? PageLoading()
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _contentFocusNode.unfocus();
              },
              child: ListView(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                children: <Widget>[
                  Offstage(
                    offstage: offstage,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 80,
                            child: TextField(
                              focusNode: _contentFocusNode,
                              controller: TextEditingController.fromValue(TextEditingValue(
                                  // 设置内容
                                  text: '$filterVal',
                                  selection: TextSelection.fromPosition(
                                      TextPosition(affinity: TextAffinity.downstream, offset: '$filterVal'.length))
                                  // 保持光标在最后
                                  )),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 10),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                              onChanged: (val) {
                                setState(() {
                                  filterVal = val;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            onPressed: _filterResult,
                          )
                        ],
                      ),
                    ),
                  ),
                  result.isEmpty
                      ? Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text('搜索无结果'),
                          ),
                        )
                      : Column(
                          children: result.map<Widget>((item) {
                            return Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Center(
                                      child: Text(
                                        item['name'],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    children: item['son'].map<Widget>((son) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 6, bottom: 6),
                                        padding: EdgeInsets.only(left: 6, right: 6, top: 4),
                                        height: 28,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
//                                          child: OutlineButton(
//                                            textTheme: ButtonTextTheme.primary,
//                                            borderSide: BorderSide(color: Colors.blue),
//                                            onPressed: () {
//                                              Navigator.push(context,
//                                                  new MaterialPageRoute(builder: (BuildContext context) {
//                                                return new SeriesName({'name': '${son['type']}'});
//                                              }));
//                                            },
//                                            padding: EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 0),
//                                            child: Text('${son['type']}'),
//                                          )
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                new MaterialPageRoute(builder: (BuildContext context) {
                                              return new SeriesName({'name': '${son['type']}'});
                                            }));
                                          },
                                          child: Baseline(
                                            baseline: 14,
                                            baselineType: TextBaseline.alphabetic,
                                            child: Text(
                                              '${son['type']}',
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
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
            ),
    );
  }
}
