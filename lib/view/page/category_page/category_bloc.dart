import 'dart:convert';
import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BaseNetwork {
  final PublishSubject<ResponseOb> _blogController = PublishSubject();

  Stream<ResponseOb> get blogStream => _blogController.stream;

  String? nextPageUrl; // Marked as nullable

  void getBlog(String id) {
    getReq(CAT_BY_URL + id, onDataCallBack: (ResponseOb resp) {
      print(resp.data);
      BlogResponseOb bro = BlogResponseOb.fromJson(resp.data);

      // Update nextPageUrl if it’s not null or empty
      if (bro.result.nextPageUrl != "null" && bro.result.nextPageUrl?.isNotEmpty == true) {
        nextPageUrl = bro.result.nextPageUrl;
      } else {
        nextPageUrl = null; // Ensure it's set to null if there's no next page
      }

      resp.pageLoad = PageLoad.first;
      resp.data = bro.result.data; // List<BlogOb>
      _blogController.sink.add(resp);
    }, errorCallBack: (ResponseOb resp) {
      _blogController.sink.add(resp);
    });
  }

  void getLoadMoreBlog(String id) {
    if (nextPageUrl == null) {
      List<BlogOb> list = [];
      ResponseOb resp = ResponseOb(
        pageLoad: PageLoad.noMore,
        message: MsgState.data,
        data: list,
      );
      _blogController.sink.add(resp);
    } else {
      getReq(nextPageUrl! + "&category_id=" + id, onDataCallBack: (ResponseOb resp) {
        BlogResponseOb bro = BlogResponseOb.fromJson(resp.data);

        if (bro.result.nextPageUrl != "null" && bro.result.nextPageUrl?.isNotEmpty == true) {
          nextPageUrl = bro.result.nextPageUrl;
          resp.pageLoad = PageLoad.nextPage;
        } else {
          nextPageUrl = null; // No more pages
        }

        resp.data = bro.result.data;
        _blogController.sink.add(resp);
      }, errorCallBack: (ResponseOb resp) {
        _blogController.sink.add(resp);
      });
    }
  }

  void dispose() {
    _blogController.close();
  }
}
