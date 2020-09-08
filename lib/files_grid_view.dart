import 'package:flutter/material.dart';
import 'package:google_drive_video_stream/video_player.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import './main.dart';
import './webview_player.dart';
import 'package:mx_player_plugin/mx_player_plugin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FilesGridView extends StatefulWidget {
  final _files;
  final String _nextPageToken;
  FilesGridView(this._files, this._nextPageToken);

  @override
  _FilesGridViewState createState() => _FilesGridViewState();
}

class _FilesGridViewState extends State<FilesGridView> {
  ScrollController _scrollController = new ScrollController();

  File fileFromDocsDir(String filename) {
    String pathName = p.join(dir, filename);
    return File(pathName);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget._files.length,
        itemBuilder: (BuildContext context, int index) {
          var item = widget._files[index];
          String url = item["hasThumbnail"]
              ? item["thumbnailLink"].toString().replaceFirst("=s220", "")
              : 'https://drive-thirdparty.googleusercontent.com/256/type/video/x-matroska';
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  height: 270,
                  width: _width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                            child: Image(
                              image: NetworkToFileImage(
                                  url: url, file: fileFromDocsDir(item["id"])),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExampleVideo(
                                        'https://www.googleapis.com/drive/v3/files/' +
                                            item["id"] +
                                            '?alt=media&key=AIzaSyAv1WgLGclLIlhKvzIiIVOiqZqDA0EM9TI')),
                              );
                            }),
                        height: 200,
                        width: _width,
                        color: Colors.black12,
                      ),
                      Container(
                        height: 70,
                        width: _width,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                item["owners"][0]["photoLink"] != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            item["owners"][0]["photoLink"]
                                                .toString()),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.brown.shade800,
                                        child: Text(item["owners"][0]
                                                ["displayName"]
                                            .toString()[0]),
                                      ),
                                Container(
                                    width: _width * 0.8,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          height: 30,
                                          width: _width * 0.8,
                                          child: Text(
                                            item["name"],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          height: 10,
                                          width: _width * 0.8,
                                          child: Text(
                                            item["owners"][0]["displayName"] +
                                                " - " +
                                                filesize(
                                                    int.parse(item["size"])),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        )
                                      ],
                                    )),
                                Divider()
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
