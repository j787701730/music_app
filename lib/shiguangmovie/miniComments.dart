import 'package:flutter/material.dart';

class MiniComments extends StatelessWidget {
  final Map comments;

  MiniComments(this.comments);

  @override
  Widget build(BuildContext context) {
    return comments.isEmpty
        ? Placeholder(
            fallbackHeight: 0,
            color: Colors.transparent,
          )
        : Column(
            children: comments['list'].map<Widget>((item) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          child: ClipOval(
                            child: Image.network(item['headImg']),
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
                    item['title'] == null
                        ? Placeholder(
                            fallbackHeight: 0,
                            color: Colors.transparent,
                          )
                        : Container(
                            child: Text(item['title']),
                          ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 15),
                      child: Text(item['content']),
                    )
                  ],
                ),
              );
            }).toList(),
          );
  }
}
