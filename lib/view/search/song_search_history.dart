import 'package:flutter/material.dart';

class SongSearchHistory extends StatefulWidget {

  List<String> history;
  ValueChanged<int> onItemTap;
  GestureTapCallback onClearTap;
  ValueChanged<int> onItemDeleteTap;

  @override
  _SongSearchHistoryState createState() => _SongSearchHistoryState();

  SongSearchHistory(this.history, {this.onItemTap, this.onClearTap,
    this.onItemDeleteTap});
}

class _SongSearchHistoryState extends State<SongSearchHistory> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Material(
            child: InkWell(
              onTap: () {
                index == widget.history.length ? widget.onClearTap() : widget.onItemTap(index);
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                    child: (index == widget.history.length)
                        ? (widget.history.length == 0
                        ? SizedBox()
                        : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0),
                        child: Text(
                          "清空搜索历史",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                      ),
                    ))
                        : Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.grey[300],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(widget.history[index],
                            style: TextStyle(
                                color: Colors.black, fontSize: 12.0)),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  index == widget.history.length
                      ? SizedBox()
                      : Positioned(
                    right: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[300],
                        ),
                        onPressed: () {
                          widget.onItemDeleteTap(index);
                        }),
                  )
                ],
              ),
            ));
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1.0,
        indent: 15.0,
      ),
      itemCount: widget.history.length + 1,
    );
  }
}
