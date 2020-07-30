import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './drive.dart';
import 'files_grid_view.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './main.dart';

class FilesListwidget extends StatefulWidget {
  @override
  _FilesListwidgetState createState() => _FilesListwidgetState();
}

class _FilesListwidgetState extends State<FilesListwidget> {
  Future _filesList;
  TextEditingController _controller = TextEditingController();
  String _searchText;
  var box = Hive.box(darkModeBox);
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    _filesList = getDriveVideos("");
    _searchText = "";
  }

  void _handleSubmitted(String value) {
    setState(() {
      _filesList = getDriveVideos(value);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var darkMode = box.get('darkMode', defaultValue: false);
            box.put('darkMode', !darkMode);
          },
          child: Icon(MdiIcons.themeLightDark),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                child: TextFormField(
                  onFieldSubmitted: _handleSubmitted,
                  onChanged: (v) {
                    setState(() {
                      _searchText = v;
                    });
                  },
                  controller: _controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(top: 16),
                      suffixIcon: IconButton(
                        icon: _searchText.length > 0
                            ? Icon(Icons.clear)
                            : Icon(MdiIcons.googleDrive),
                        onPressed: () {
                          _controller.clear();
                        },
                      ),
                      hintText: 'Search Drive'),
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: _filesList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FilesGridView(
                      snapshot.data["files"], snapshot.data["nextPageToken"]);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Icon(Icons.error),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        )
                      ],
                    ),
                  );
                }
              },
            )),
          ],
        )));
  }
}
