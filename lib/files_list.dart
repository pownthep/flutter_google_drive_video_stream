import 'package:flutter/material.dart';
import './drive.dart';
import 'files_grid_view.dart';

class FilesListwidget extends StatefulWidget {
  @override
  _FilesListwidgetState createState() => _FilesListwidgetState();
}

class _FilesListwidgetState extends State<FilesListwidget> {
  Future _filesList;

  @override
  void initState() {
    super.initState();
    _filesList = getDriveVideos("");
  }

  void _handleSubmitted(String value) {
    setState(() {
      _filesList = getDriveVideos(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onFieldSubmitted: _handleSubmitted,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a search term'),
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
        ))
      ],
    )));
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}
