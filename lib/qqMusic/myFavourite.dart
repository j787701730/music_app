import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFavourite extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;

  MyFavourite(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs);

  @override
  _MyFavouriteState createState() => _MyFavouriteState();
}

class _MyFavouriteState extends State<MyFavourite> {
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    count = 0;

    return Scaffold(
      body: widget.myFavouriteSongs == null
          ? null
          : ListView(
              children: widget.myFavouriteSongs.map<Widget>((item) {
                count += 1;
                return Container(
                  padding: EdgeInsets.only(bottom: 5,top: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee),width: 1)
                    )
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Center(
                          child: Text('$count'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: InkWell(
                            onTap: () {
                              widget.getSongUrl({'songmid': '${item['songmid']}',
                                'songname': '${item['songname']}',
                                'singer': '${item['name']}'});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    '${item['songname']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    item['singer'],
                                    style: TextStyle(color: Color(0xff777777)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        child: InkWell(
                          onTap: () {
                            widget.changeFavourite({
                              'songmid': '${item['songmid']}',
                              'songname': '${item['songname']}',
                              'singer': '${item['singer']}',
                            }, false);
                          },
                          child: Icon(
                            Icons.clear,
                            color: Color(0xFF31C27C),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
