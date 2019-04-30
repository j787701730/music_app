import 'package:flutter/material.dart';
import '../utils/util.dart';
import '../pageLoading.dart';

class SongListCategory extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavouriteSongsList;

  SongListCategory(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs, this.myFavouriteSongsList);

  @override
  _SongListCategoryState createState() => _SongListCategoryState();
}

class _SongListCategoryState extends State<SongListCategory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSongListCategory();
  }

  Map songListCategory;
  Map categories;

  getSongListCategory() {
    ajax('/songListCategory?key=579621905', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        Map d = {};
        for (var o in data['sub']) {
          if (d[o['category']] == null) {
            d[o['category']] = [o];
          } else {
            d[o['category']].add(o);
          }
        }
        setState(() {
          songListCategory = d;
          categories = data['categories'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthTo4 = (MediaQuery.of(context).size.width - 20) / 4;
    return Scaffold(
      appBar: AppBar(
        title: Text('歌单广场'),
      ),
      body: songListCategory == null
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.all(10),
              children: songListCategory.keys.map<Widget>((item) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[Icon(Icons.library_music), Text(' ${categories['$item']}')],
                        ),
                      ),
                      Wrap(
                        children: songListCategory[item].map<Widget>((item) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            width: widthTo4,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFF3F3F3), borderRadius: BorderRadius.all(Radius.circular(30))),
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Center(
                                  child: Text(item['name']),
                                ),
                                onTap: () {},
                              ),
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
