import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';

class PlayerScreen extends StatefulWidget {
  String? audioUrl;

  PlayerScreen({this.audioUrl, super.key});

  @override
  State<PlayerScreen> createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> {

  final assetsAudioPlayer = AssetsAudioPlayer();
  double? initialValue = 0;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }


  Future<void> initPlayer() async {
    print('init methods:::::::::');
    print('song played::::::${widget.audioUrl.toString()}');
    try {
      await assetsAudioPlayer.open(Audio.network(widget.audioUrl.toString()),
          forceOpen: true,
          audioFocusStrategy: AudioFocusStrategy.none(),
          autoStart: true,
          loopMode: LoopMode.playlist);
      if(assetsAudioPlayer.isPlaying.value){
        setState(() {
          loading = false;
        });
      }
      await assetsAudioPlayer.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    loading = false;
    await assetsAudioPlayer.dispose();
    super.dispose();
   // assetsAudioPlayer.dispose();
  }

  String getLabel({String? label,int? duration,int? total}){
    int shours = Duration(milliseconds:label == 'current'?duration?? 0: total ?? 0).inHours;
    int sminutes = Duration(milliseconds:label == 'current'?duration ?? 0: total ?? 0).inMinutes;
    int sseconds = Duration(milliseconds:label == 'current'?duration ?? 0: total ?? 0).inSeconds;

    int rhours = shours;
    int rminutes = sminutes - (shours * 60);
    int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

   return "$rhours:$rminutes:$rseconds";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightgrey,
      body: GestureDetector(
        onTap: () {
          assetsAudioPlayer.playOrPause();
          if (!assetsAudioPlayer.isPlaying.value) {
            assetsAudioPlayer.play();
          } else {
            assetsAudioPlayer.pause();
          }
        },
        child: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return
                Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    assetsAudioPlayer.builderRealtimePlayingInfos(
                  builder: (context, RealtimePlayingInfos? infos) {
                    initialValue = infos!.currentPosition.inMilliseconds.toDouble();
                if (infos == null) {
                  return SizedBox();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      height: 9,
                      child: Slider(
                        activeColor: AppColor.primarycolor,
                          value: initialValue ?? 0 ,
                          min: 0.0,
                          max: infos.duration.inMilliseconds.toDouble(),
                          onChanged: (double value) async {
                            setState(() {
                              print('initialValue is>>${initialValue}');
                              assetsAudioPlayer.seek(Duration(milliseconds: value?.round() ?? 0));
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getLabel(label: 'current',duration:initialValue!.toInt() ),style: TextStyle(color: Colors.white,fontSize: 13),),

                          Text(getLabel(label: 'total',total:infos.duration.inMilliseconds ),style: TextStyle(color: Colors.white,fontSize: 13),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    StreamBuilder<bool>(
                      stream: assetsAudioPlayer.isPlaying,
                      builder: (context, snapshot) {
                        bool? playingState = snapshot.data;
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColor.primarycolor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: MediaQuery.of(context).size.width / 10,
                          height: MediaQuery.of(context).size.width / 10,
                          child: Icon(
                            playingState != null && playingState
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: AppColor.loginappbar,
                            size: playingState != null && playingState
                                ?MediaQuery.of(context).size.width / 14:MediaQuery.of(context).size.width / 13,
                          ),
                        );
                      },
                    ),

                  ],
                );
              }),
                  ],
                )
              );
            }),
      )
    );
  }
}

class DurationState {
  const DurationState({this.progress, this.buffered, this.total});

  final Duration? progress;
  final Duration? buffered;
  final Duration? total;
}
