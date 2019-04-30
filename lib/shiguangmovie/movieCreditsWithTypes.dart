import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';
import '../pageLoading.dart';
import 'personDetail.dart';

class MovieCreditsWithTypes extends StatefulWidget {
  final Map props;

  MovieCreditsWithTypes(this.props);

  @override
  _MovieCreditsWithTypesState createState() => _MovieCreditsWithTypesState();
}

class _MovieCreditsWithTypesState extends State<MovieCreditsWithTypes> {
  List types = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTypes();
  }

  _getTypes() {
    ajax('https://api-m.mtime.cn/Movie/MovieCreditsWithTypes.api?movieId=${widget.props['movieId']}', (data) {
      print(data);
      if (!mounted) return;
      Map obj = jsonDecode(data);
      setState(() {
        types = obj['types'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.props['title']),
      ),
      body: types.isEmpty
          ? PageLoading()
          : ListView(
              children: types.map<Widget>((item) {
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Center(
                        child: Text(
                          item['typeName'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Column(
                      children: item['persons'].map<Widget>((person) {
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                return new PersonDetail({'name': person['name'], 'id': '${person['id']}'});
                              }));
                            },
                            child: Column(
                              children: <Widget>[
                                Image.network(person['image']),
                                Container(
                                  child: Center(
                                    child: Text(person['name']),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text(person['nameEn']),
                                  ),
                                ),
                                person['personate'] == null
                                    ? Placeholder(
                                        fallbackHeight: 0,
                                        color: Colors.transparent,
                                      )
                                    : Container(
                                        child: Center(
                                          child: Text('饰: ${person['personate']}(${person['personateCn']})'),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                );
              }).toList(),
            ),
    );
  }
}
