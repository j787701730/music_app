import 'package:flutter/material.dart';
import '../pageLoading.dart';
import 'util.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

//import 'musicPlayer.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'commentWidget.dart';
import 'authorList.dart';

class MusicContent extends StatefulWidget {
  final params;

  MusicContent(this.params);

  @override
  _MusicContentState createState() => _MusicContentState(params);
}

class _MusicContentState extends State<MusicContent> {
  final params;

  _MusicContentState(this.params);

  Map article = {};
  Map comments = {};
//  AudioPlayer audioPlayer = new AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMusic();
    _getComment();
  }

  _getMusic() {
    ajax('http://v3.wufazhuce.com:8000/api/music/detail/${params['item_id']}', (data) {
      print(jsonEncode(data));
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          article = data['data'];
//          audioPlayer.play(data['data']['music_id']);
        });
      }
    });
  }

  _getComment() {
    ajax('http://v3.wufazhuce.com:8000/api/comment/praiseandtime/music/${params['item_id']}/0', (data) {
      print('评论');
      print(jsonEncode(data));
      if (!mounted) return;
      if (data['res'] == 0) {
        setState(() {
          comments = data['data'];
        });
      }
    });
  }

  @override
  void dispose() {
//    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params['title']),
      ),
      body: article.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  height: 100,
                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(article['cover']))),
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                  ),
                ),
//                MusicPlayer(url: article['music_id']),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  child: Text(
                    article['story_title'],
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('文 / ${article['author']['user_name']}'),
                ),
//                NewsDetailsWeb(body: article['hp_content']),
                Html(
                  data: article['story'],
                  padding: EdgeInsets.only(left: 20, right: 20),
                  defaultTextStyle: TextStyle(
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text(
                    '${article['charge_edt']} ${article['editor_email']}',
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    '作者',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      height: 4,
                      width: 60,
                      color: Colors.black87,
                    ),
                  ],
                ),
                AuthorList(article),
                Container(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    '评论列表',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      height: 4,
                      width: 60,
                      color: Colors.black87,
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                CommentsWidget(comments)
              ],
            ),
    );
  }
}
