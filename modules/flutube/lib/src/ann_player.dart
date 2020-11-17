import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ANNPlayer extends StatefulWidget {
  const ANNPlayer(this.url, {Key key, this.child}) : super(key: key);

  final String url;
  final Widget child;

  @override
  _ANNPlayerState createState() => _ANNPlayerState();
}

class _ANNPlayerState extends State<ANNPlayer> {
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
    return youtubeHierarchy();
  }

  youtubeHierarchy() {
    final size = MediaQuery.of(context).size;
    final isFull = size.height < size.width;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
      ),
      builder: (context, player) {
        if(isFull || widget.child == null){
          return Center(child: player);
        }
        return ListView(
          children: [
            player,
            widget.child
          ],
        );
      },
    );
  }

  void listener() {
    // print(_controller.value);
  }
}
