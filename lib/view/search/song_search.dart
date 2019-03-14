import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/navigator/kugou_navigator.dart';
import 'package:flutter_kugou/view/search/bean/song_search_bean.dart';
import 'package:flutter_kugou/view/search/song_search_bloc.dart';
import 'package:flutter_kugou/view/search/song_search_history.dart';
import 'package:flutter_kugou/view/search/song_name_search_list.dart';
import 'package:flutter_kugou/view/search/song_search_list.dart';
import 'package:flutter_kugou/view/search/song_search_list_bloc.dart';

class SongSearch extends StatefulWidget {
  @override
  _SongSearchState createState() => _SongSearchState();
}

class _SongSearchState extends BaseState<SongSearch, SongSearchBloc> {
  bool isFirst = true;
  FocusNode _focusNode;
  String _search;
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _search = "光年之外";
    _searchController = TextEditingController(text: _search);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    bloc.readSearchHistory();
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
            _buildSearch("光年之外"),
            Expanded(
              child: SizedBox(),
            ),
            _buildCancel(context)
          ],
        ),
      ),
      body: _focusNode.hasFocus || _search.isEmpty
          ? StreamBuilder(
              initialData: bloc.searchCache,
              stream: bloc.songSearch,
              builder:
                  (BuildContext context, AsyncSnapshot<SearchBean> snapshot) {
                return snapshot.data == null
                    ? StreamBuilder(
                        initialData: bloc.historyCache,
                        stream: bloc.searchHistory,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> historyData) {
                          return SongSearchHistory(historyData.data,
                              onItemTap: (index) {
                            searchSong(historyData.data[index]);
                          }, onClearTap: () {
                            bloc.deleteAllSearchHistory();
                          }, onItemDeleteTap: (index) {
                            bloc.deleteSearchHistory(historyData.data[index]);
                          });
                        },
                      )
                    : SongNameSearchList(
                        snapshot.data.data.map((val) => val.keyword).toList(),
                        search: _search, onItemTap: (index) {
                        searchSong(snapshot.data.data[index].keyword);
                      });
              },
            )
          : BlocProvider<SongSearchListBloc>(
              child: SongSearchList(),
              bloc: SongSearchListBloc(_search),
            ),
    );
  }

  // 搜索歌曲
  void searchSong(String songName, {isEdit = false}) {
    setState(() {
      _search = songName;
      bloc.searchSongName(_search);
      if (!isEdit) {
        _focusNode.unfocus();
        _searchController.text = _search;
        bloc.saveSearchHistory(songName);
      }
    });
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
              searchSong(str, isEdit: true);
            },
            controller: _searchController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: 14.0, height: 1.2),
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
