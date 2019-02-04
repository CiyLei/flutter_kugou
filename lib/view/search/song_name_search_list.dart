import 'package:flutter/material.dart';

class SongNameSearchList extends StatefulWidget {

  List<String> songs;
  String search;
  ValueChanged<int> onItemTap;


  SongNameSearchList(this.songs, {this.search, this.onItemTap});

  @override
  _SongNameSearchListState createState() => _SongNameSearchListState();
}

class _SongNameSearchListState extends State<SongNameSearchList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {
              widget.onItemTap(index);
            },
            child: Padding(
              padding:
              const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RichText(
                    text: TextSpan(
                      text: widget.search,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.0),
                      children: widget.songs[index].split(widget.search).map((val) {
                        return val.isEmpty
                            ? TextSpan()
                            : TextSpan(
                            text: val,
                            style: TextStyle(
                                color: Colors.black, fontSize: 12.0),
                            children: [
                              TextSpan(
                                text: !widget.songs[index].endsWith(val) ||
                                    widget.songs[index].endsWith(widget.search)
                                    ? widget.search
                                    : "",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12.0),
                              )
                            ]);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1.0,
        indent: 15.0,
      ),
      itemCount: widget.songs.length,
    );
  }
}
