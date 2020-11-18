import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyYoutube extends StatefulWidget {
  const MyYoutube(
    this.url, {
    Key key,
    this.showFullButton = true,
  }) : super(key: key);

  final String url;
  final bool showFullButton;

  @override
  _MyYoutubeState createState() => _MyYoutubeState();
}

class _MyYoutubeState extends State<MyYoutube> {
  @override
  void initState() {
    super.initState();
    final videoID = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        bottomActions: widget.showFullButton ? null : [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
        ],
      ),
      builder: (context, player) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            player,
          ],
        );
      },
    );
  }
}
