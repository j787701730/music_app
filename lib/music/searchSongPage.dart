import 'package:flutter/material.dart';

class SearchSongPage extends StatelessWidget {
  final props;
  final getSongUrl;

  SearchSongPage(this.props,this.getSongUrl);

  @override
  Widget build(BuildContext context) {
    return props['data'].isEmpty
        ? Placeholder(
            fallbackHeight: 1,
            color: Colors.transparent,
          )
        : ListView(
            children: props['data'].map<Widget>((song) {
              return ListTile(
                leading: Text('${props['data'].indexOf(song) + 1}'),
                title: Text(song['name']),
                subtitle: Text(song['singer']),
                onTap: () {
                  getSongUrl([song]);
                },
              );
            }).toList(),
          );
  }
}
