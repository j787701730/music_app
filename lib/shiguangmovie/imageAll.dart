import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import 'dart:convert';

class ImageAll extends StatefulWidget {
  final props;

  ImageAll(this.props);

  @override
  _ImageAllState createState() => _ImageAllState();
}

class _ImageAllState extends State<ImageAll> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getImages();
  }

  List images = [];

  _getImages() {
    ajax('https://api-m.mtime.cn/Movie/ImageAll.api?movieId=${widget.props['movieId']}', (data) {
      if (!mounted) return;
      var obj = jsonDecode(data);
      setState(() {
        images = obj['images'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.props);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.props['title']}剧照'),
      ),
      body: images.isEmpty
          ? PageLoading()
          : ListView(
              children: images.map<Widget>((item) {
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Image.network(item['image']),
                );
              }).toList(),
            ),
    );
  }
}
