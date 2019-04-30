import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';

class Mini extends StatefulWidget {
  final Map props;

  Mini(this.props);

  @override
  _MiniState createState() => _MiniState();
}

class _MiniState extends State<Mini> {
  List cts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCts();
  }

  _getCts() {
    ajax('https://api-m.mtime.cn/Showtime/HotMovieComments.api?pageIndex=1&movieId=${widget.props['movieId']}', (data) {
      if (!mounted) return;
      setState(() {
        cts = data['data']['cts'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.props['title']}短评'),
      ),
      body: cts.isEmpty
          ? PageLoading()
          : ListView(
              padding: EdgeInsets.all(10),
              children: cts.map<Widget>((item) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: ClipOval(
                              child: Image.network(item['caimg']),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(item['ca']),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(item['ce']),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
