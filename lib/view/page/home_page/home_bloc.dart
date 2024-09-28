import 'dart:convert';
import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:blog_tuto_ap/view/page/home_page/category_response_ob.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseNetwork {
  final PublishSubject<ResponseOb> categoryController = PublishSubject();
  final PublishSubject<ResponseOb> blogController = PublishSubject();

  String? nextPageUrl;

  // Stream for category data
  Stream<ResponseOb> categoryStream() => categoryController.stream;

  // Stream for blog data
  Stream<ResponseOb> blogStream() => blogController.stream;

  // Fetch categories
  void getCategory() {
    SharedPref.getData(key: SharedPref.category).then((str) {
      if (str != null && str != "null") {
        ResponseOb resp = ResponseOb(message: MsgState.data);
        resp.data = CategoryResponseOb.fromJson(json.decode(str)).result; // List<CategoryOb>
        categoryController.sink.add(resp);
      }
    });

    getReq(CAT_URL,
        onDataCallBack: (ResponseOb resp) {
          print(resp.data);

          SharedPref.setData(key: SharedPref.category, value: json.encode(resp.data));

          resp.data = CategoryResponseOb.fromJson(resp.data).result; // List<CategoryOb>
          categoryController.sink.add(resp);
        },
        errorCallBack: (ResponseOb resp) {
          categoryController.sink.add(resp);
        }
    );
  }

  // Fetch blogs
  void getBlog() {
    getReq(POST_URL,
        onDataCallBack: (ResponseOb resp) {
          print(resp.data);

          BlogResponseOb bro = BlogResponseOb.fromJson(resp.data);
          nextPageUrl = bro.result.nextPageUrl != "null" ? bro.result.nextPageUrl : null;

          resp.pageLoad = PageLoad.first;
          resp.data = bro.result.data; // List<BlogOb>
          blogController.sink.add(resp);
        },
        errorCallBack: (ResponseOb resp) {
          blogController.sink.add(resp);
        }
    );
  }

  // Load more blogs
  void getLoadMoreBlog() {
    if (nextPageUrl == null) {
      ResponseOb resp = ResponseOb(pageLoad: PageLoad.noMore, message: MsgState.data, data: []);
      blogController.sink.add(resp);
    } else {
      getReq(nextPageUrl!,
          onDataCallBack: (ResponseOb resp) {
            BlogResponseOb bro = BlogResponseOb.fromJson(resp.data);
            nextPageUrl = bro.result.nextPageUrl != "null" ? bro.result.nextPageUrl : null;

            resp.pageLoad = nextPageUrl == null ? PageLoad.noMore : PageLoad.nextPage;
            resp.data = bro.result.data;
            blogController.sink.add(resp);
          },
          errorCallBack: (ResponseOb resp) {
            blogController.sink.add(resp);
          }
      );
    }
  }

  // Dispose the controllers
  void dispose() {
    categoryController.close();
    blogController.close();
  }
}
