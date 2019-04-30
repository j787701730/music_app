import 'package:flutter/material.dart';
import 'util.dart';
import '../pageLoading.dart';
import 'chapterContent.dart';

class Chapters extends StatefulWidget {
  final Map props;

  Chapters(this.props);

  @override
  _ChaptersState createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  Map mixToc = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getChapters();
    print(widget.props['id']);  }

  _getChapters() {
    ajax('http://api.zhuishushenqi.com/mix-atoc/${widget.props['id']}?view=chapters', (data) {
      if (!mounted) return;
      setState(() {
        mixToc = data['mixToc'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.props['title']} 章节'),
      ),
      body: mixToc.isEmpty
          ? PageLoading()
          : ListView(
              children: mixToc['chapters'].map<Widget>((item) {
                return ListTile(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                      return new ChapterContent({'title': item['title'], 'link': item['link']});
                    }));
                  },
                  title: Text(item['title']),
                );
              }).toList(),
            ),
    );
  }
}
