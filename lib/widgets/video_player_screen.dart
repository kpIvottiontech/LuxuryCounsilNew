import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

late YoutubePlayerController ytbPlayerController;
class youtubeWidget extends StatefulWidget {
  final String? url;
  const youtubeWidget({@required this.url});


  @override
  State<youtubeWidget> createState() => youtubeWidgetState();
}

class youtubeWidgetState extends State<youtubeWidget> {
  //late YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  String videoId = YoutubePlayer.convertUrlToId(widget.url.toString())!;
    /*print('videoId---->${videoId}');
    _controller = YoutubePlayerController(
      initialVideoId: '-BYWbosiYlw',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );*/



    ytbPlayerController = YoutubePlayerController(
      initialVideoId: '${widget.url}',
      params: YoutubePlayerParams(
        showFullscreenButton: true,
        strictRelatedVideos: false,
        autoPlay: false,
      ),
    );

    ytbPlayerController.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      print('Entered Fullscreen');
    };
    ytbPlayerController.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      print('Exited Fullscreen');
    };
    /* WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {

      });
    });*/
  }
  @override
  void dispose() {
    print('yes disposing:::');
    super.dispose();
    ytbPlayerController.close();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _buildYtbView(),
      ],
    );

  }
  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 12 / 9,
      child: ytbPlayerController != null
          ? GestureDetector(
          onTap: (){
            print( 'tap here >>${ytbPlayerController.onEnterFullscreen}');
          },
          child: YoutubePlayerIFrame(controller: ytbPlayerController,))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
