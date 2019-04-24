import 'package:flutter/material.dart';
import '../utils/util.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../pageLoading.dart';

class Mv extends StatefulWidget {
  final props;

  Mv(this.props);

  @override
  _MvState createState() => _MvState();
}

class _MvState extends State<Mv> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mv();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Map mvData = {};

  mv() {
    ajax('/mv?key=579621905&id=${widget.props['id']}', (data) {
      if (!mounted) return;
      if (data['code'] == 200) {
        setState(() {
          mvData = data['data'];
        });
        _videoPlayerController = VideoPlayerController.network(data['data']['url']);
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.props['title']),
      ),
      body: mvData.isNotEmpty
          ? ListView(
              padding: EdgeInsets.only(left: 10, right: 10),
              children: <Widget>[
                Container(
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(mvData['name']),
                ),
                Container(
                  child: Text(
                    mvData['desc'],
                    style: TextStyle(color: Color(0xff666666)),
                  ),
                )
              ],
            )
          : PageLoading(),
    );
  }
}
