import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import 'dart:convert';
import 'moviePlay.dart';

class Video extends StatefulWidget {
  final Map props;

  Video(this.props);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  List videoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVideo();
  }

  _getVideo() {
    ajax('https://api-m.mtime.cn/Movie/Video.api?pageIndex=1&movieId=${widget.props['movieId']}', (data) {
      print(data);
      if (!mounted) return;
      Map obj = jsonDecode(data);
      setState(() {
        videoList = obj['videoList'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.props['title']),
      ),
      body: videoList.isEmpty
          ? PageLoading()
          : ListView(
              children: videoList.map<Widget>((item) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                      return new MoviePlay({'title': item['title'], 'url': item['url']});
                    }));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.contain),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(item['title']),
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
