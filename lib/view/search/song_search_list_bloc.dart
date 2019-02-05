import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/net/request_warehouse.dart';
import 'package:flutter_kugou/view/search/search_songs_bean.dart';
import 'dart:async';

class SongSearchListBloc extends BlocBase{

  String song;
  int _page = 1;
  bool isMore = false;

  StreamController<List<SearchSongsInfoData>> _searchSongController = StreamController();
  Stream<List<SearchSongsInfoData>> get searchSong => _searchSongController.stream;
  List<SearchSongsInfoData> _data = List();

  SongSearchListBloc(this.song) {
    refresh();
  }

  void refresh() {
    RequestWareHouse.instance().getSearchSong(song).then((SearchSongsBean bean) {
      _page = 1;
      isMore = bean.data.info.length > 0;
      _data.clear();
      _data.addAll(bean.data.info);
      _searchSongController.add(bean.data.info);
    });
  }

  void getNext() {
    RequestWareHouse.instance().getSearchSong(song, page: ++_page).then((SearchSongsBean bean) {
      isMore = bean.data.info.length > 0;
      _data.addAll(bean.data.info);
      _searchSongController.add(_data);
    });
  }

  @override
  void dispose() {
    _searchSongController.close();
  }

}