import 'package:flutter/material.dart';

class Sing extends StatefulWidget {
  @override
  _SingState createState() => _SingState();
}

class _SingState extends State<Sing> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
