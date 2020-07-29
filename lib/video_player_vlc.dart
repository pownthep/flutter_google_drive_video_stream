// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// class VLCPlayer extends StatefulWidget {
//   final String _id;
//   final String _size;
//   final String _name;

//   VLCPlayer(this._id, this._size, this._name);

//   @override
//   _VLCPlayerState createState() => new _VLCPlayerState();
// }

// class _VLCPlayerState extends State<VLCPlayer> {
//   VlcPlayerController controller;
//   bool isPlaying = true;
//   double sliderValue = 0.0;
//   double currentPlayerTime = 0;

//   @override
//   void initState() {
//     controller = new VlcPlayerController(onInit: () {
//       controller.play();
//     });
//     controller.addListener(() {
//       setState(() {});
//     });

//     Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       String state = controller.playingState.toString();
//       if (this.mounted) {
//         setState(() {
//           if (state == "PlayingState.PLAYING" &&
//               sliderValue < controller.duration.inSeconds) {
//             sliderValue = controller.position.inSeconds.toDouble();
//           }
//         });
//       }
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String url =
//         "http://192.168.1.17:4040?id=${widget._id}&size=${widget._size}";
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: ListView(
//         children: <Widget>[
//           Container(
//             child: VlcPlayer(
//                 aspectRatio: 16 / 9, url: url, controller: controller),
//           ),
//           Slider(
//             activeColor: Colors.red,
//             inactiveColor: Colors.red[50],
//             value: sliderValue,
//             min: 0.0,
//             max: controller.duration == null
//                 ? 1.0
//                 : controller.duration.inSeconds.toDouble(),
//             onChanged: (progress) {
//               setState(() {
//                 sliderValue = progress.floor().toDouble();
//               });
//               controller.pause();
//               //convert to Milliseconds since VLC requires MS to set time
//               controller.setTime(sliderValue.toInt() * 1000);
//               controller.play();
//             },
//           ),
//           FlatButton(
//               child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
//               onPressed: () => {playOrPauseVideo()}),
//         ],
//       ),
//     );
//   }

//   void playOrPauseVideo() {
//     String state = controller.playingState.toString();

//     if (state == "PlayingState.PLAYING") {
//       controller.pause();
//       setState(() {
//         isPlaying = false;
//       });
//     } else {
//       controller.play();
//       setState(() {
//         isPlaying = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
// }
