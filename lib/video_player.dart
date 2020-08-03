import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class ExampleVideo extends StatefulWidget {
  final String _url;
  ExampleVideo(this._url);

  @override
  _ExampleVideoState createState() => _ExampleVideoState();
}

class _ExampleVideoState extends State<ExampleVideo> {
  VlcPlayerController _videoViewController;
  bool _visible;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _videoViewController = new VlcPlayerController(
        // Start playing as soon as the video is loaded.
        onInit: () {
      _videoViewController.play();
    });
    _visible = true;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double playerWidth = MediaQuery.of(context).size.width;
    final double playerHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
            height: playerHeight,
            width: playerWidth,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  if (_visible)
                    SystemChrome.setEnabledSystemUIOverlays([]);
                  else
                    SystemChrome.setEnabledSystemUIOverlays(
                        SystemUiOverlay.values);
                  _visible = !_visible;
                });
              },
              child: Stack(
                children: <Widget>[
                  VLCPlayerWidget(
                      playerWidth: playerWidth,
                      playerHeight: playerHeight,
                      widget: widget,
                      videoViewController: _videoViewController),
                  AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: ControlOverlay(
                        playerWidth: playerWidth,
                        playerHeight: playerHeight,
                        videoViewController: _videoViewController),
                  )
                ],
              ),
            )));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

class ControlOverlay extends StatefulWidget {
  const ControlOverlay({
    Key key,
    @required this.playerWidth,
    @required this.playerHeight,
    @required VlcPlayerController videoViewController,
  })  : _videoViewController = videoViewController,
        super(key: key);

  final double playerWidth;
  final double playerHeight;
  final VlcPlayerController _videoViewController;

  @override
  _ControlOverlayState createState() => _ControlOverlayState();
}

class _ControlOverlayState extends State<ControlOverlay> {
  bool isPlaying = true;
  double sliderValue = 0.0;
  double currentPlayerTime = 0;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      String state = widget._videoViewController.playingState.toString();
      if (this.mounted) {
        setState(() {
          if (state == "PlayingState.PLAYING" &&
              sliderValue < widget._videoViewController.duration.inSeconds) {
            sliderValue =
                widget._videoViewController.position.inSeconds.toDouble();
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            iconSize: 38,
          ),
        ),
        Spacer(),
        Container(
          child: Center(
            child: IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              onPressed: () {
                playOrPauseVideo();
              },
              iconSize: 72,
            ),
          ),
        ),
        Spacer(),
        Slider(
          activeColor: Colors.white,
          inactiveColor: Colors.white70,
          label: sliderValue.toString(),
          value: sliderValue,
          min: 0.0,
          max: widget._videoViewController.duration == null
              ? 1.0
              : widget._videoViewController.duration.inSeconds.toDouble(),
          onChanged: (progress) {
            print(progress);
            setState(() {
              sliderValue = progress.floor().toDouble();
            });
            //convert to Milliseconds since VLC requires MS to set time
            widget._videoViewController.setTime(sliderValue.toInt() * 1000);
          },
        ),
      ],
    );
  }

  void playOrPauseVideo() {
    String state = widget._videoViewController.playingState.toString();

    if (state == "PlayingState.PLAYING") {
      widget._videoViewController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      widget._videoViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }
}

class VLCPlayerWidget extends StatelessWidget {
  const VLCPlayerWidget({
    Key key,
    @required this.playerWidth,
    @required this.playerHeight,
    @required this.widget,
    @required VlcPlayerController videoViewController,
  })  : _videoViewController = videoViewController,
        super(key: key);

  final double playerWidth;
  final double playerHeight;
  final ExampleVideo widget;
  final VlcPlayerController _videoViewController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new VlcPlayer(
        aspectRatio: playerWidth / playerHeight,
        url: widget._url,
        controller: _videoViewController,
        placeholder: Container(
          height: 250.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[CircularProgressIndicator()],
          ),
        ),
      ),
    );
  }
}
