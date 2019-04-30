import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool requesting;

  Loading(this.requesting);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !requesting,
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          margin: EdgeInsets.only(right: 10),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }
}
