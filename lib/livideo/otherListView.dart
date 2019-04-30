import 'package:flutter/material.dart';
import '../pageLoading.dart';
import 'detailContent.dart';

class CommonListView extends StatelessWidget {
  final data;

  CommonListView(this.data);

  @override
  Widget build(BuildContext context) {
    print(data);
    return Container(
      child: data.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      '热门',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: data['hotList'].map<Widget>((list) {
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(list['pic']), fit: BoxFit.fitWidth)),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 4),
                              child: Text('${list['name']}'),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                          return new DetailContent({'contId': list['contId'], 'title': list['name']});
                        }));
                      },
                    );
                  }).toList(),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      '列表',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: data['contList'].map<Widget>((list) {
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(list['pic']), fit: BoxFit.fitWidth)),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 4),
                              child: Text('${list['name']}'),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                          return new DetailContent({'contId': list['contId'], 'title': list['name']});
                        }));
                      },
                    );
                  }).toList(),
                )
              ],
            ),
    );
  }
}
