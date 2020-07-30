import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import './sign_in.dart';

String token;
var cache = new Map();

Future<dynamic> getDriveVideos(String text) async {
  if (token == null) {
    token = await signInWithGoogle();
  }
  String key = text.length == 0 ? "default" + token : text + token;
  if (cache[key] != null) return json.decode(cache[key]);
  String url = text.length == 0
      ? 'https://www.googleapis.com/drive/v3/files?orderBy=recency%20desc&pageSize=100&q=mimeType%20contains%20"video"&fields=nextPageToken,files(name,id,size,hasThumbnail,thumbnailLink,iconLink,owners(displayName,photoLink))'
      : 'https://www.googleapis.com/drive/v3/files?orderBy=recency%20desc&q=mimeType%20contains%20"video"%20and%20name%20contains%20"$text"&fields=nextPageToken,files(name,id,size,hasThumbnail,thumbnailLink,iconLink,owners(displayName,photoLink))';
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
