import 'dart:convert' show json;

class SongInfoBean {

  int err_code;
  int status;
  SongInfoData data;

  SongInfoBean.fromParams({this.err_code, this.status, this.data});

  factory SongInfoBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SongInfoBean.fromJson(json.decode(jsonStr)) : new SongInfoBean.fromJson(jsonStr);

  SongInfoBean.fromJson(jsonRes) {
    err_code = jsonRes['err_code'];
    status = jsonRes['status'];
    data = jsonRes['data'] == null ? null : new SongInfoData.fromJson(jsonRes['data']);
  }

  @override
  bool operator ==(other) {
    if (other is SongInfoBean) {
      return this.data.hash == other.data.hash;
    }
    return false;
  }

  @override
  String toString() {
    return '{"err_code": $err_code,"status": $status,"data": $data}';
  }
}

class SongInfoData {

  int bitrate;
  int filesize;
  int have_album;
  int have_mv;
  int privilege;
  int timelength;
  String album_id;
  String album_name;
  String audio_name;
  String author_id;
  String author_name;
  String hash;
  String img;
  String lyrics;
  String play_url;
  String privilege2;
  String song_name;
  dynamic video_id;
  List<SongInfoAuthors> authors;

  SongInfoData.fromParams({this.bitrate, this.filesize, this.have_album, this.have_mv, this.privilege, this.timelength, this.album_id, this.album_name, this.audio_name, this.author_id, this.author_name, this.hash, this.img, this.lyrics, this.play_url, this.privilege2, this.song_name, this.video_id, this.authors});

  SongInfoData.fromJson(jsonRes) {
    bitrate = jsonRes['bitrate'];
    filesize = jsonRes['filesize'];
    have_album = jsonRes['have_album'];
    have_mv = jsonRes['have_mv'];
    privilege = jsonRes['privilege'];
    timelength = jsonRes['timelength'];
    album_id = jsonRes['album_id'];
    album_name = jsonRes['album_name'];
    audio_name = jsonRes['audio_name'];
    author_id = jsonRes['author_id'];
    author_name = jsonRes['author_name'];
    hash = jsonRes['hash'];
    img = jsonRes['img'];
    lyrics = jsonRes['lyrics'];
    play_url = jsonRes['play_url'];
    privilege2 = jsonRes['privilege2'];
    song_name = jsonRes['song_name'];
    video_id = jsonRes['video_id'];
    authors = jsonRes['authors'] == null ? null : [];

    for (var authorsItem in authors == null ? [] : jsonRes['authors']){
      authors.add(authorsItem == null ? null : new SongInfoAuthors.fromJson(authorsItem));
    }
  }

  @override
  String toString() {
    return '{"bitrate": $bitrate,"filesize": $filesize,"have_album": $have_album,"have_mv": $have_mv,"privilege": $privilege,"timelength": $timelength,"album_id": ${album_id != null?'${json.encode(album_id)}':'null'},"album_name": ${album_name != null?'${json.encode(album_name)}':'null'},"audio_name": ${audio_name != null?'${json.encode(audio_name)}':'null'},"author_id": ${author_id != null?'${json.encode(author_id)}':'null'},"author_name": ${author_name != null?'${json.encode(author_name)}':'null'},"hash": ${hash != null?'${json.encode(hash)}':'null'},"img": ${img != null?'${json.encode(img)}':'null'},"lyrics": ${lyrics != null?'${json.encode(lyrics)}':'null'},"play_url": ${play_url != null?'${json.encode(play_url)}':'null'},"privilege2": ${privilege2 != null?'${json.encode(privilege2)}':'null'},"song_name": ${song_name != null?'${json.encode(song_name)}':'null'},"video_id": ${video_id != null?'${json.encode(video_id)}':'null'},"authors": $authors}';
  }
}

class SongInfoAuthors {

  String author_id;
  String author_name;
  String avatar;
  String is_publish;
  String sizable_avatar;

  SongInfoAuthors.fromParams({this.author_id, this.author_name, this.avatar, this.is_publish, this.sizable_avatar});

  SongInfoAuthors.fromJson(jsonRes) {
    author_id = jsonRes['author_id'];
    author_name = jsonRes['author_name'];
    avatar = jsonRes['avatar'];
    is_publish = jsonRes['is_publish'];
    sizable_avatar = jsonRes['sizable_avatar'];
  }

  @override
  String toString() {
    return '{"author_id": ${author_id != null?'${json.encode(author_id)}':'null'},"author_name": ${author_name != null?'${json.encode(author_name)}':'null'},"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},"is_publish": ${is_publish != null?'${json.encode(is_publish)}':'null'},"sizable_avatar": ${sizable_avatar != null?'${json.encode(sizable_avatar)}':'null'}}';
  }
}

