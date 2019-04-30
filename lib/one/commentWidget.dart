import 'package:flutter/material.dart';

class CommentsWidget extends StatelessWidget {
  final comments;

  CommentsWidget(this.comments);

  @override
  Widget build(BuildContext context) {
    return comments.isEmpty
        ? Placeholder(
            fallbackHeight: 1,
            color: Colors.transparent,
          )
        : Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              children: comments['data'].map<Widget>((comment) {
                return Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.black),
                            width: 20,
                            height: 20,
                            child: ClipOval(
                              child: Image.network(
                                '${comment['user']['web_url']}',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(comment['user']['user_name']),
                            ),
                          ),
                          SizedBox(
                            child: Text(comment['input_date']),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(comment['content']),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            color: Colors.black38,
                            size: 16,
                          ),
                          Text(
                            ' ${comment['praisenum']}',
                            style: TextStyle(color: Colors.black38),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
  }
}
