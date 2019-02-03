import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'dart:async';

class HomePageBloc extends BlocBase{

  StreamController<double> _searchHeightController = StreamController.broadcast();
  Stream<double> get searchHeightStream => _searchHeightController.stream;

  bool _searchIsExpand = true;
  bool get searchIsExpand => _searchIsExpand;

  void expandSearch() {
    _searchHeightController.sink.add(0.0);
    _searchIsExpand = true;
  }

  void closeSearch() {
    _searchHeightController.sink.add(50.0);
    _searchIsExpand = false;
  }

  @override
  void dispose() {
    _searchHeightController.close();
  }

}