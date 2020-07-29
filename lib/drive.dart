import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import './sign_in.dart';

String token;
var cache = new Map();

Future<dynamic> getDriveVideos(String text) async {
  String key = text.length == 0 ? "default" : text;
  if (cache[key] != null) return json.decode(cache[key]);
  if (token == null) {
    token = await signInWithGoogle();
  }
  String url = text.length == 0
      ? 'https://www.googleapis.com/drive/v3/files?&pageSize=1000&q=mimeType="video/mp4"&fields=nextPageToken,files(name,id,size,hasThumbnail,thumbnailLink,iconLink)'
      : 'https://www.googleapis.com/drive/v3/files?&pageSize=1000&q=mimeType="video/mp4"%20and%20name%20contains%20"$text"&fields=nextPageToken,files(name,id,size,hasThumbnail,thumbnailLink,iconLink)';
  Response res = await get(url, headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json'
  });
  if (res.statusCode == 200) {
    cache[key] = res.body;
    return json.decode(cache[key]);
  } else {
    print("Error");
  }
}
