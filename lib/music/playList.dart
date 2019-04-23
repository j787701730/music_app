import 'package:flutter/material.dart';

class PlayList extends StatefulWidget {
  final myPlaySongsList;
  final getSongUrl;
  final changePlayList;
  final currPlaySong;

  PlayList(this.myPlaySongsList, this.getSongUrl, this.changePlayList, this.currPlaySong);

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: widget.myPlaySongsList.map<Widget>((item) {
            bool playicon = false;
            if (widget.currPlaySong['songmid'] == item['songmid']) {
              playicon = true;
            }

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
                      child: playicon ? Icon(Icons.volume_up,color: Color(0xFF31C27C),size: 20,) : Text('${widget.myPlaySongsList.indexOf(item) + 1}'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          widget.getSongUrl({
                            'songmid': '${item['songmid']}',
                            'songname': '${item['songname']}',
                            'singer': '${item['singer']}'
                          });
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
                        widget.changePlayList({
                          'songmid': '${item['songmid']}',
                          'songname': '${item['songname']}',
                          'singer': '${item['singer']}',
                        }, false);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Color(0xFF31C27C),
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
