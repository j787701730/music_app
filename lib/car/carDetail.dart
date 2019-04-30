import 'package:flutter/material.dart';
import 'dart:convert';
import 'util.dart';
import 'carItem.dart';
import '../pageLoading.dart';

class CarDetail extends StatefulWidget {
  final params;

  CarDetail(this.params);

  @override
  _CarDetailState createState() => _CarDetailState(params);
}

class _CarDetailState extends State<CarDetail> {
  final params;

  _CarDetailState(this.params);

  List result = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMsg();
  }

  _getMsg() {
    ajax('http://apicloud.mob.com/car/series/query?cid=${params['cid']}', (data) {
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
        title: Text('${params['seriesName']}'),
      ),
      body: result.isEmpty
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.all(10),
              children: result.map<Widget>((res) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        res['carImage'],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '基本参数',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['baseInfo']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '车身',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['carbody']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '高科技配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['techConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '发动机',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['engine']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '变速箱',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['transmission']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '底盘转向',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['chassis']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '车轮制动',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['wheelInfo']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '主/被动安全装备',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['safetyDevice']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '辅助/操控配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['controlConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '外部/防盗配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['exterConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '内部配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['interConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '座椅配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['seatConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '多媒体配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['mediaConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '灯光配置',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['lightConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '玻璃/后视镜',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['glassConfig']),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '空调/冰箱',
                        style: TextStyle(color: Color.fromRGBO(153, 48, 0, 1)),
                      ),
                    ),
                    CarItem(res['airConfig']),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
