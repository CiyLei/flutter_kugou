import 'package:meta/meta.dart';

class CollectionModel {

  CollectionModel({@required this.name, @required this.imageUrl, this.songNum = 0, this.downLoadNum = 0});

  String name;
  String imageUrl;
  int songNum;
  int downLoadNum;
}