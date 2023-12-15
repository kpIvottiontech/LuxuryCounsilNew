import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final String? url;
  const LocalVideoPlayer({this.url,super.key});

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
 /* List<DeviceOrientation> _preferredOrientations = [DeviceOrientation.portraitUp];

  late ChewieController chewieController;*/
  late FlickManager flickManager;

 /* @override
  void initState() {
    chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(
        widget.url!,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: true,
        ),
      ),
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft],
      allowFullScreen: true,
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
      systemOverlaysOnEnterFullScreen: SystemUiOverlay.values,
      allowMuting: true,
      progressIndicatorDelay: null,
    );
    SystemChrome.setPreferredOrientations(_preferredOrientations);
    chewieController.addListener(_handleFullScreenChange);

    super.initState();
  }

  void _handleFullScreenChange() {
    if (chewieController.isFullScreen) {
      print('testing1');
      if (Platform.isIOS) {
        print('testing2');
        _preferredOrientations = [DeviceOrientation.landscapeLeft];
      }
    } else {
      print('testing3');
      _preferredOrientations = [DeviceOrientation.portraitUp];
    }
    print('testing4');
    SystemChrome.setPreferredOrientations(_preferredOrientations);
  }


  @override
  void dispose() {
    print('yes disposing:::');
    super.dispose();
    chewieController.removeListener(_handleFullScreenChange);
    chewieController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }*/

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(widget.url!),
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _buildYtbView(),
      ],
    );

  }
/*  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: chewieController != null
          ?  Chewie(
        controller: chewieController,
      )
          : Center(child: CircularProgressIndicator()),
    );
  }*/
  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: flickManager != null
          ?  FlickVideoPlayer(
        flickManager: flickManager,
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
