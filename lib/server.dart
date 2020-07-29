import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import './drive.dart';

Future startServer() async {
  var server = await HttpServer.bind(
    "192.168.1.17",
    4040,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest req in server) {
    try {
      //File file = await _localFile;
      String id = req.uri.queryParameters["id"];
      String size = req.uri.queryParameters["size"];
      if (req.headers.value("Range") != null) {
        List<String> range = req.headers.value("Range").split("-");
        int start = int.parse(range[0].replaceFirst("bytes=", ""));
        print("Range: " + req.headers.value("Range"));
        int end = int.parse(size) - 1;
        req.response.statusCode = HttpStatus.partialContent;
        req.response.headers.add("Content-Range", "bytes $start-$end/$size");
        req.response.headers.add("Accept-Ranges", "bytes");
        req.response.headers.add("Content-Length", end - start + 1);
        req.response.headers.add("Content-Type", "video/mp4");
        // RandomAccessFile raf = await file.open();
        // RandomAccessFile chunk = await raf.setPosition(start);
        // Future<Uint8List> f = chunk.read(end - start + 1);
        var httpClient = http.Client();
        var request = new http.Request(
            'GET',
            Uri.parse(
                'https://www.googleapis.com/drive/v3/files/$id?alt=media'));
        request.headers["Authorization"] = "Bearer " + token;
        request.headers["Range"] = 'bytes=$start-$end';
        var response = httpClient.send(request);
        response.asStream().listen((http.StreamedResponse r) {
          r.stream.listen((List<int> chunk) {
            req.response.add(chunk);
          }, onDone: () {
            print("Download complete");
            httpClient.close();
            req.response.close();
          }, onError: (e) {
            print(e.toString());
          });
        });
        req.response.done.then((value) {
          print("Consumer closed");
          httpClient.close();
          req.response.close();
        }).catchError((e) {
          print("Socket Error");
          httpClient.close();
          req.response.close();
        });
      } else {
        req.response.headers.add("Content-Type", "video/mp4");
        var httpClient = http.Client();
        var request = new http.Request(
            'GET',
            Uri.parse(
                'https://www.googleapis.com/drive/v3/files/$id?alt=media'));
        request.headers["Authorization"] = "Bearer " + token;
        var response = httpClient.send(request);
        response.asStream().listen((http.StreamedResponse r) {
          r.stream.listen((List<int> chunk) {
            // Display percentage of completion
            req.response.add(chunk);
          }, onDone: () async {
            // Display percentage of completion
            print("Done");
            httpClient.close();
            req.response.close();
          }, onError: (e) => {print(e.toString())});
        });
        req.response.done.then((value) {
          print("Consumer closed");
          httpClient.close();
          req.response.close();
        }).catchError((e) {
          print("Socket Error");
          httpClient.close();
          req.response.close();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<String> get _localPath async {
  final directory = await getExternalStorageDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/video');
}
