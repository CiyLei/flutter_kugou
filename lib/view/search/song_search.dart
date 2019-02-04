import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/component/navigator/kugou_navigator.dart';
import 'package:flutter_kugou/view/search/song_search_bean.dart';
import 'package:flutter_kugou/view/search/song_search_bloc.dart';

class SongSearch extends StatefulWidget {
  @override
  _SongSearchState createState() => _SongSearchState();
}

class _SongSearchState extends BaseState<SongSearch, SongSearchBloc> {
  bool isFirst = true;
  FocusNode _focusNode;
  String _search;

  @override
  void initState() {
    super.initState();
    _search = "";
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirst) {
      FocusScope.of(context).requestFocus(_focusNode);
      isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            _buildSearch("SING女团 团团圆圆"),
            Expanded(
              child: SizedBox(),
            ),
            _buildCancel(context)
          ],
        ),
      ),
      body: StreamBuilder(
        initialData: null,
        stream: bloc.songSearch,
        builder: (BuildContext context, AsyncSnapshot<SearchBean> snapshot) {
          return snapshot.data == null
              ? Container(
                  color: Colors.orangeAccent,
                )
              : _buildSearchList(snapshot);
        },
      ),
    );
  }

  ListView _buildSearchList(AsyncSnapshot<SearchBean> snapshot) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {},
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
                      text: _search,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.0),
                      children: snapshot.data.data[index].keyword
                          .split(_search)
                          .map((val) {
                        return val.isEmpty
                            ? TextSpan()
                            : TextSpan(
                                text: val,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0),
                                children: [
                                    TextSpan(
                                      text: !snapshot.data.data[index].keyword
                                                  .endsWith(val) ||
                                              snapshot.data.data[index].keyword
                                                  .endsWith(_search)
                                          ? _search
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
      itemCount: snapshot.data.data.length,
    );
  }

  Widget _buildSearch(String label) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          height: 35.0,
          padding: const EdgeInsets.only(left: 40.0),
          width: MediaQuery.of(context).size.width - 100.0,
          decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.all(
                  Radius.circular((kToolbarHeight - 10) / 2.0))),
          child: TextField(
            focusNode: _focusNode,
            onChanged: (str) {
              setState(() {
                _search = str;
                bloc.searchSong(_search);
              });
            },
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: 14.0),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 7.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.mic_none,
                color: Colors.white54,
                size: 30.0,
              ),
              _search.isNotEmpty
                  ? SizedBox()
                  : Text(
                      label,
                      style: TextStyle(color: Colors.white54, fontSize: 14.0),
                    )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCancel(BuildContext context) {
    return GestureDetector(
      onTap: () {
        KuGouNavigator.of(context).pop();
      },
      child: Container(
        width: 60.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Text(
          "取消",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}
