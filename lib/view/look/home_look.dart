import 'package:flutter/material.dart';

class Look extends StatefulWidget {
  @override
  _LookState createState() => _LookState();
}

class _LookState extends State<Look> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
