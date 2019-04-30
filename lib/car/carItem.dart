import 'package:flutter/material.dart';

class CarItem extends StatelessWidget {
  final data;

  CarItem(this.data);

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Container(
            child: Center(
              child: Text('无详细数据'),
            ),
          )
        : Column(
            children: data.map<Widget>((item) {
              return Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      item['name'],
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(item['value']),
                  )
                ],
              );
            }).toList(),
          );
  }
}
