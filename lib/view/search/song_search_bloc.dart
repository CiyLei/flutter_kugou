import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'dart:async';

import 'package:flutter_kugou/component/net/request_warehouse.dart';
import 'package:flutter_kugou/view/search/song_search_bean.dart';


class SongSearchBloc extends BlocBase{

  StreamController<SearchBean> _songSearchController = StreamController.broadcast();
  Stream<SearchBean> get songSearch => _songSearchController.stream;
  SearchBean searchCache = null;

  void searchSong(String song) {
    if (song.isNotEmpty) {
      RequestWareHouse.instance().getSearchSong(song).then((searchBean) {
        searchCache = searchBean;
        _songSearchController.add(searchBean);
      });
    }
    searchCache = null;
    _songSearchController.add(null);
  }

  @override
  void dispose() {
    _songSearchController.close();
  }

}