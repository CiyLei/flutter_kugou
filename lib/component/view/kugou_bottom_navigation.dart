import 'package:flutter/material.dart';

class KuGouBottomNavigation extends StatefulWidget {

  KuGouBottomNavigation({
    @required this.imgUrl,
    @required this.song,
    @required this.author,
  });

  String imgUrl;
  String song;
  String author;

  @override
  _KuGouBottomNavigationState createState() => _KuGouBottomNavigationState();
}

class _KuGouBottomNavigationState extends State<KuGouBottomNavigation> {
  double progress;

  @override
  void initState() {
    super.initState();
    progress = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey[100], offset: Offset(0.0, -1.0))
            ],
          ),
          height: 60.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 75.0),
            child: Column(
              children: <Widget>[
                _buildProgress(context, this.progress),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.song,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                              Text(
                                widget.author,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          size: 35.0,
                        ),
                        padding: EdgeInsets.zero,
//                        iconSize: 40.0,
                        onPressed: () {
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.playlist_play),
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
          child: CircleAvatar(
            radius: 31.0,
            backgroundColor: Colors.grey[300],
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(widget.imgUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(BuildContext context, double progress) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      height: 15.0,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Colors.grey,
          thumbColor: Theme.of(context).primaryColor,

          activeTickMarkColor: Theme.of(context).primaryColor,
          inactiveTickMarkColor: Colors.grey,
        ),
        child: Slider(
          value: progress,
          onChanged: (value) {
            setState(() {
              this.progress = value.floorToDouble();
            });
          },
          label: "$progress",
          min: 0.0,
          max: 100.0,
          divisions: 100,
        ),
      ),
    );
  }
}
