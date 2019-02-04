import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/component/navigator/kugou_navigator.dart';
import 'package:flutter_kugou/view/search/song_search_bean.dart';
import 'package:flutter_kugou/view/search/song_search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongSearch extends StatefulWidget {
  @override
  _SongSearchState createState() => _SongSearchState();
}

class _SongSearchState extends BaseState<SongSearch, SongSearchBloc> {
  bool isFirst = true;
  FocusNode _focusNode;
  String _search;
  TextEditingController _searchController;
  List<String> searchHistory;

  @override
  void initState() {
    super.initState();
    _search = "";
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    searchHistory = [];
    getSearchHistory().then((val) {
      setState(() {
        searchHistory = val;
      });
    });
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
      body: _focusNode.hasFocus || _search.isEmpty
          ? StreamBuilder(
              initialData: bloc.searchCache,
              stream: bloc.songSearch,
              builder:
                  (BuildContext context, AsyncSnapshot<SearchBean> snapshot) {
                return snapshot.data == null
                    ? _buildSearchHisotyList(searchHistory, onItemTap: (index) {
                        searchSong(searchHistory[index]);
                      }, onClearTap: () {
                        deleteAllSearchHistory();
                      }, onItemDeleteTap: (index) {
                        deleteSearchHistory(searchHistory[index]);
                      })
                    : _buildSearchList(
                        snapshot.data.data.map((val) => val.keyword).toList(),
                        onItemTap: (index) {
                        searchSong(snapshot.data.data[index].keyword);
                      });
              },
            )
          : Container(
              color: Colors.green,
            ),
    );
  }

  Widget _buildSearchHisotyList(List<String> history,
      {ValueChanged<int> onItemTap,
      GestureTapCallback onClearTap,
      ValueChanged<int> onItemDeleteTap}) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Material(
            child: InkWell(
          onTap: () {
            index == history.length ? onClearTap() : onItemTap(index);
          },
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                child: (index == history.length)
                    ? (history.length == 0
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
                          Text(history[index],
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0)),
                          Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
              ),
              index == history.length
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
                            onItemDeleteTap(index);
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
      itemCount: history.length + 1,
    );
  }

  ListView _buildSearchList(List<String> songs, {ValueChanged<int> onItemTap}) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {
              onItemTap(index);
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
                      text: _search,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.0),
                      children: songs[index].split(_search).map((val) {
                        return val.isEmpty
                            ? TextSpan()
                            : TextSpan(
                                text: val,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0),
                                children: [
                                    TextSpan(
                                      text: !songs[index].endsWith(val) ||
                                              songs[index].endsWith(_search)
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
      itemCount: songs.length,
    );
  }

  // 搜索歌曲
  void searchSong(String songName, {isEdit = false}) {
    setState(() {
      _search = songName;
      bloc.searchSong(_search);
      if (!isEdit) {
        _focusNode.unfocus();
        _searchController.text = _search;
        saveSearchHistory(songName);
      }
    });
  }

  // 保存搜索记录
  void saveSearchHistory(String str) async {
    deleteSearchHistory(str, inserStr: str);
  }

  // 读取搜索记录
  Future<List<String>> getSearchHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList("SearchHistory") ?? [];
  }

  // 删除某个搜索记录
  void deleteSearchHistory(String str, {String inserStr}) async {
    List<String> searchHistory = await getSearchHistory();
    searchHistory.remove(str);
    if (inserStr != null && inserStr.isNotEmpty) {
      searchHistory.insert(0, inserStr);
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList("SearchHistory", searchHistory);
    setState(() {
      this.searchHistory = searchHistory;
    });
  }

  // 删除全部的搜索记录
  void deleteAllSearchHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList("SearchHistory", []);
    setState(() {
      this.searchHistory = [];
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
