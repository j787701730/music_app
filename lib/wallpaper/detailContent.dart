import 'package:flutter/material.dart';
import 'util.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../pageLoading.dart';

class DetailContent extends StatefulWidget {
  final params;

  DetailContent(this.params);

  @override
  _DetailContentState createState() => _DetailContentState(params);
}

class _DetailContentState extends State<DetailContent> {
  final params;

  _DetailContentState(this.params);

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  String videoUrl;
  Map content = {};
  List relateConts = [];
  List comments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDetail();
  }

  _getDetail() {
    ajax('http://app.pearvideo.com/clt/jsp/v2/content.jsp?contId=${params['contId']}', (data) {
      if (!mounted) return;
      setState(() {
        content = data['content'];
        relateConts = data['relateConts'];
        comments = data['postInfo']['childList'];
        videoUrl = data['content']['videos'][1]['url'];
        _videoPlayerController = VideoPlayerController.network(videoUrl);
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: false,
          // Try playing around with some of these other options:

          // showControls: false,
          // materialProgressColors: ChewieProgressColors(
          //   playedColor: Colors.red,
          //   handleColor: Colors.blue,
          //   backgroundColor: Colors.grey,
          //   bufferedColor: Colors.lightGreen,
          // ),
          placeholder: Container(
            color: Colors.grey,
          ),
          autoInitialize: true,
        );
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params['title']),
      ),
      body: content.isEmpty
          ? PageLoading()
          : ListView(
              children: <Widget>[
                Container(
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: Text(content['name']),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: Row(
                    children: <Widget>[
                      Text(content['authors'].isEmpty ? '' : content['authors'][0]['nickname']),
                      Text(' '),
                      Text(content['pubTime']),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: Text(content['summary']),
                ),
                relateConts.length == 0
                    ? Placeholder(
                        fallbackHeight: 1,
                        color: Colors.transparent,
                      )
                    : Column(
                        children: relateConts.map<Widget>((relateCont) {
                          return Container(
                            padding: EdgeInsets.all(6),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
                                  return new DetailContent({'contId': relateCont['contId'], 'title': relateCont['name']});
                                }));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 3,
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: NetworkImage(relateCont['pic']), fit: BoxFit.fitHeight)),
                                      child: Center(
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: Text(relateCont['name']),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('评论'),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: comments.isEmpty
                      ? Container(
                    padding: EdgeInsets.only(bottom: 10),
                          child: Text('无评论'),
                        )
                      : Column(
                          children: comments.map<Widget>((childList) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 80,
                                    child: Image.network(
                                      childList['userInfo']['pic'],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(childList['userInfo']['nickname']),
                                          ),
                                          Container(
                                            child: Text(childList['content']),
                                          ),
                                          Container(
                                            child: Text(childList['pubTime']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                )
              ],
            ),
    );
  }
}
