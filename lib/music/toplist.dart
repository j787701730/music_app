import 'package:flutter/material.dart';
import 'songList.dart';

class TopList extends StatefulWidget {
  final getSongUrl;
  final changeFavourite;
  final myFavouriteSongs;
  final myFavouriteSongsList;

  TopList(this.getSongUrl, this.changeFavourite, this.myFavouriteSongs, this.myFavouriteSongsList);

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _highQualitySongList();
  }

  @override
  bool get wantKeepAlive => true;
  List topList = [
    {
      'name': '云音乐特色榜',
      'items': [
        {
          'name': '云音乐飙升榜',
          'id': '19723756',
          'src': 'https://p1.music.126.net/DrRIg6CrgDfVLEph9SNh7w==/18696095720518497.jpg?param=40y40'
        },
        {
          'name': '云音乐新歌榜',
          'id': '3779629',
          'src': 'https://p1.music.126.net/N2HO5xfYEqyQ8q6oxCw8IQ==/18713687906568048.jpg?param=40y40'
        },
        {
          'name': '网易原创歌曲榜',
          'id': '2884035',
          'src': 'https://p1.music.126.net/sBzD11nforcuh1jdLSgX7g==/18740076185638788.jpg?param=40y40'
        },
        {
          'name': '云音乐热歌榜',
          'id': '3778678',
          'src': 'https://p1.music.126.net/GhhuF6Ep5Tq9IEvLsyCN7w==/18708190348409091.jpg?param=40y40'
        },
      ]
    },
    {
      'name': '全球媒体榜',
      'items': [
        {
          'name': '新声榜',
          'id': '2617766278',
          'src': 'https://p1.music.126.net/XbjRDARP1xv5a-40ZDOy6A==/109951163785427934.jpg?param=40y40'
        },
        {
          'name': '江小白YOLO云音乐说唱榜',
          'id': '991319590',
          'src': 'https://p1.music.126.net/TuGxihwbiPmoHoFGvIuu_w==/109951163781770038.jpg?param=40y40'
        },
        {
          'name': '云音乐古典音乐榜',
          'id': '71384707',
          'src': 'https://p1.music.126.net/BzSxoj6O1LQPlFceDn-LKw==/18681802069355169.jpg?param=40y40'
        },
        {
          'name': '云音乐电音榜',
          'id': '1978921795',
          'src': 'https://p1.music.126.net/5tgOCD4jiPKBGt7znJl-2g==/18822539557941307.jpg?param=40y40'
        },
        {
          'name': '抖音排行榜',
          'id': '2250011882',
          'src': 'https://p1.music.126.net/bZvjH5KTuvAT0YXlVa-RtQ==/109951163326845001.jpg?param=40y40'
        },
        {
          'name': '云音乐ACG音乐榜',
          'id': '71385702',
          'src': 'https://p1.music.126.net/vttjtRjL75Q4DEnjRsO8-A==/18752170813539664.jpg?param=40y40'
        },
        {
          'name': '云音乐韩语榜',
          'id': '745956260',
          'src': 'https://p2.music.126.net/vs-cMh49e6qPEorHuhU07A==/18737877162497499.jpg?param=40y40'
        },
        {
          'name': '云音乐国电榜',
          'id': '10520166',
          'src': 'https://p2.music.126.net/8-GBrukQ3BHhs4CmK6qE4w==/109951163424197392.jpg?param=40y40'
        },
        {
          'name': '英国Q杂志中文版周榜',
          'id': '2023401535',
          'src': 'https://p2.music.126.net/0_6_Efe9m0D0NtghOxinUg==/109951163089272193.jpg?param=40y40'
        },
        {
          'name': '电竞音乐榜',
          'id': '2006508653',
          'src': 'https://p2.music.126.net/CUqQp33MZf_m0BwH4u0V6A==/109951163078922993.jpg?param=40y40'
        },
        {
          'name': 'UK排行榜周榜',
          'id': '180106',
          'src': 'https://p2.music.126.net/VQOMRRix9_omZbg4t-pVpw==/18930291695438269.jpg?param=40y40'
        },
        {
          'name': '美国Billboard周榜',
          'id': '60198',
          'src': 'https://p2.music.126.net/EBRqPmY8k8qyVHyF8AyjdQ==/18641120139148117.jpg?param=40y40'
        },
        {
          'name': 'Beatport全球电子舞曲榜',
          'id': '3812895',
          'src': 'https://p2.music.126.net/A61n94BjWAb-ql4xpwpYcg==/18613632348448741.jpg?param=40y40'
        },
        {
          'name': '法国 NRJ Vos Hits 周榜',
          'id': '27135204',
          'src': 'https://p2.music.126.net/6O0ZEnO-I_RADBylVypprg==/109951162873641556.jpg?param=40y40'
        },
        {
          'name': 'KTV唛榜',
          'id': '21845217',
          'src': 'https://p2.music.126.net/H4Y7jxd_zwygcAmPMfwJnQ==/19174383276805159.jpg?param=40y40'
        },
        {
          'name': 'iTunes榜',
          'id': '11641012',
          'src': 'https://p2.music.126.net/WTpbsVfxeB6qDs_3_rnQtg==/109951163601178881.jpg?param=40y40'
        },
        {
          'name': '日本Oricon周榜',
          'id': '60131',
          'src': 'https://p2.music.126.net/Rgqbqsf4b3gNOzZKxOMxuw==/19029247741938160.jpg?param=40y40'
        },
        {
          'name': 'Hit FM Top榜',
          'id': '120001',
          'src': 'https://p2.music.126.net/54vZEZ-fCudWZm6GH7I55w==/19187577416338508.jpg?param=40y40'
        },
        {
          'name': '台湾Hito排行榜',
          'id': '112463',
          'src': 'https://p2.music.126.net/wqi4TF4ILiTUUL5T7zhwsQ==/18646617697286899.jpg?param=40y40'
        },
        {
          'name': '香港电台中文歌曲龙虎榜',
          'id': '10169002',
          'src': 'https://p2.music.126.net/YQsr07nkdkOyZrlAkf0SHA==/18976471183805915.jpg?param=40y40'
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double oneIn3 = (MediaQuery.of(context).size.width - 10) / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text('排行榜'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10,bottom: 10),
        children: topList.map<Widget>((item) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 6, bottom: 6),
                child: Text(
                  item['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: item['items'].map<Widget>((el) {
                  return Container(
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 5,bottom: 5,left: 5),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              el['src'],
                              width: 40,
                              height: 40,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(el['name']),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                          return new SongList({
                            'id': '${el['id']}',
                            'title': '${el['name']}',
                          }, widget.getSongUrl, widget.changeFavourite, widget.myFavouriteSongs,
                              widget.myFavouriteSongsList);
                        }));
                      },
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
