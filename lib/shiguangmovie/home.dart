import 'package:flutter/material.dart';
import 'hotPlayMovies.dart';
import 'locationMovies.dart';
import 'movieComingNew.dart';

class ShiGuangHome extends StatefulWidget {
  _ShiGuangHomeState createState() => _ShiGuangHomeState();
}

class _ShiGuangHomeState extends State<ShiGuangHome> with SingleTickerProviderStateMixin {
  List<Widget> list = List();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new TabBarView(
            controller: _tabController, children: <Widget>[HotPlayMovies(), LocationMovies(), MovieComingNew()]),
        bottomNavigationBar: Material(
          child: SafeArea(
              child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFd0d0d0),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            height: 48,
            child: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black26,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(fontSize: 12),
              tabs: <Tab>[
                Tab(
                    child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.store_mall_directory), Text('正在售票')],
                  ),
                )),
                Tab(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Icon(Icons.whatshot), Text('正在热映')],
                      )),
                ),
                Tab(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Icon(Icons.access_time), Text('即将上映')],
                      )),
                ),
              ],
              controller: _tabController,
            ),
          )),
        ));
  }
}
