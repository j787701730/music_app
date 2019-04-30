import 'package:flutter/material.dart';
import 'movie/home.dart';
import 'weather/home.dart';
import 'livideo/home.dart';
import 'one/home.dart';
import 'tiku/home.dart';
import 'stock/home.dart';
import 'car/home.dart';
import 'meiriyiwen/home.dart';
import 'transit/home.dart';
import 'shiguangmovie/home.dart';
import 'wallpaper/home.dart';
import 'reader/home.dart';

class Index extends StatelessWidget {

  List pages = [
    {'name': '豆瓣电影', 'icon': Icons.movie, 'home': MovieHome()},
    {'name': '时光电影', 'icon': Icons.local_movies, 'home': ShiGuangHome()},
    {'name': '天气', 'icon': Icons.filter_drama, 'home': WeatherHome()},
    {'name': '梨视频', 'icon': Icons.video_label, 'home': LiHome()},
    {'name': 'ONE', 'icon': Icons.video_label, 'home': OneHome()},
    {'name': '驾照题库', 'icon': Icons.directions_car, 'home': TiKuHome()},
    {'name': '汽车信息', 'icon': Icons.local_taxi, 'home': CarHome()},
    {'name': '每日一文', 'icon': Icons.import_contacts, 'home': MeiRiHome()},
    {'name': '360壁纸', 'icon': Icons.wallpaper, 'home': WallPaperHome()},
    {'name': '小说', 'icon': Icons.book, 'home': ReaderHome()},
    {'name': '全球股指', 'icon': Icons.trending_up, 'home': StockHome()},
    {'name': '公交(福州)', 'icon': Icons.directions_bus, 'home': TransitHome()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('整合'),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 10),
          children: <Widget>[
            Wrap(
              children: pages.map<Widget>((item) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              item['icon'],
                              size: 30,
                              color: Color(0xff666666),
                            ),
                            Container(
                              height: 20,
                              child: Center(
                                child: Text(
                                  '${item['name']}',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                        return item['home'];
                      }));
                    },
                  ),
                );
              }).toList(),
            )
          ],
        ));
  }
}
