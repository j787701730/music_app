import 'package:flutter/material.dart';

class AuthorList extends StatelessWidget {
  final article;

  AuthorList(this.article);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: article['author_list'].map<Widget>((list) {
          return Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.black),
                width: 44,
                height: 44,
                child: ClipOval(
                  child: Image.network(
                    '${list['web_url']}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          list['user_name'],
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      Container(
                        child: Text(list['desc'], style: TextStyle(height: 1.5)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
