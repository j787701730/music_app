import 'package:flutter/material.dart';
//import 'splashPage.dart';
import 'music/home.dart';
import 'rxdart/blocProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: 'music App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, platform: TargetPlatform.iOS),
        home: MusicHome(),
      ),
    );
  }
}
