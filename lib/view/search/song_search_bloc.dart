import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'dart:async';

import 'package:flutter_kugou/component/net/request_warehouse.dart';
import 'package:flutter_kugou/view/search/song_search_bean.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongSearchBloc extends BlocBase {

  StreamController<SearchBean> _songSearchController =
      StreamController.broadcast();
  Stream<SearchBean> get songSearch => _songSearchController.stream;
  // 如果StreamBuilder被重新build的话，就会加载初始值，所以这里做了保存。这样StreamBuilder的AsyncSnapshot就没什么意义了
  SearchBean searchCache = null;

  StreamController<List<String>> _searchHistoryController =
      StreamController.broadcast();
  Stream<List<String>> get searchHistory => _searchHistoryController.stream;
  List<String> historyCache = List();

  void searchSongName(String songName) {
    if (songName.isNotEmpty) {
      RequestWareHouse.instance().getSearchSongName(songName).then((searchBean) {
        searchCache = searchBean;
        _songSearchController.add(searchBean);
      });
      return;
    }
    searchCache = null;
    _songSearchController.add(null);
  }

  // 读取搜索记录
  void readSearchHistory() async {
    var list = await getSearchHistory();
    historyCache = list;
    _searchHistoryController.add(list);
  }

  // 保存搜索记录
  void saveSearchHistory(String str) async {
    deleteSearchHistory(str, inserStr: str);
  }

  // 获取搜索记录
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
    historyCache = searchHistory;
    _searchHistoryController.add(searchHistory);
  }

  // 删除全部的搜索记录
  void deleteAllSearchHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList("SearchHistory", []);
    historyCache = [];
    _searchHistoryController.add([]);
  }

  @override
  void dispose() {
    _songSearchController.close();
    _searchHistoryController.close();
  }
}
