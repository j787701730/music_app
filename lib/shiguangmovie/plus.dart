import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';

class Plus extends StatefulWidget {
  final Map props;

  Plus(this.props);

  @override
  _PlusState createState() => _PlusState();
}

class _PlusState extends State<Plus> {
  List comments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCts();
  }

  _getCts() {
    ajax('https://api-m.mtime.cn/Movie/HotLongComments.api?pageIndex=1&movieId=${widget.props['movieId']}', (data) {
      if (!mounted) return;
      setState(() {
        comments = data['comments'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.props['title']}精评'),
      ),
      body: comments.isEmpty
        ? PageLoading()
        : ListView(
        padding: EdgeInsets.all(10),
        children: comments.map<Widget>((item) {
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
                        child: Image.network(item['headurl']),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(item['nickname']),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(item['title']),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(item['content']),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
