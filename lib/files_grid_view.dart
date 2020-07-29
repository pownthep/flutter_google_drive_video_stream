import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import './main.dart';
import './video_player_vlc.dart';
import './webview_player.dart';

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
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget._files.length,
      itemBuilder: (BuildContext context, int index) {
        var item = widget._files[index];
        String url = item["hasThumbnail"]
            ? item["thumbnailLink"].toString().replaceFirst("=s220", "")
            : 'https://drive-thirdparty.googleusercontent.com/256/type/video/x-matroska';
        return Container(
          height: 250,
          width: _width,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewExample(
                        'http://192.168.1.17:4040?id=${item["id"]}&size=${item["size"]}')),
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Image(
                    image: NetworkToFileImage(
                        url: url, file: fileFromDocsDir(item["id"])),
                    fit: BoxFit.cover,
                  ),
                  height: 200,
                  width: _width,
                  color: Colors.black12,
                ),
                Container(
                  height: 50,
                  width: _width,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item["name"])),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
