import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {
  Future<Map<String, dynamic>> fetchNews(String categories) async {
    final dio = Dio();
    Response response =
        await dio.get("https://inshorts.deta.dev/news?category=$categories");

    // log(response.data.toString());
    return response.data;
  }

  Future<Map<String, dynamic>> search(String query) async {
    final dio = Dio();
    final response = await dio.get("https://inshorts.me/news/search",
        queryParameters: {"query": query, "offset": 0, "limit": 10});
    // log(response.data.toString());
    return response.data;
  }
}
