import 'dart:convert';
import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_ob.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_response_post_ob.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../home_page/blog_response_ob.dart';

class ProfileBloc extends BaseNetwork {
  // Stream controller for profile data
  final PublishSubject<ResponseOb<ProfileOb>> profileController = PublishSubject();
  Stream<ResponseOb<ProfileOb>> profileStream() => profileController.stream;

  // Stream controller for blog posts
  final PublishSubject<ResponseOb<List<BlogOb>>> blogController = PublishSubject();
  Stream<ResponseOb<List<BlogOb>>> blogStream() => blogController.stream;

  // Fetch the user profile
  Future<void> getProfile() async {
    SharedPref.getData(key: SharedPref.profile).then((str) {
      if (str != null && str.toString() != "null") {
        // Create ResponseOb with type ProfileOb
        ResponseOb<ProfileOb> resp = ResponseOb<ProfileOb>(message: MsgState.data);
        resp.data = ProfileResponseOb.fromJson(json.decode(str)).result;
        profileController.sink.add(resp);
      }
    });

    getReq(PROFILE_URL, onDataCallBack: (ResponseOb<dynamic> resp) {
      if (resp.data['success'] == true) {
        SharedPref.setData(key: SharedPref.profile, value: json.encode(resp.data));
        // Cast resp.data to ProfileResponseOb and set it to resp.data
        resp.data = ProfileResponseOb.fromJson(resp.data).result as ProfileOb; // Explicit cast
        resp.message = MsgState.data; // Update message state
      } else {
        resp.message = MsgState.error; // Handle error case
        resp.errState = ErrState.serverError; // Update error state
      }
      // Cast resp to ResponseOb<ProfileOb>
      profileController.sink.add(resp as ResponseOb<ProfileOb>); // Explicit cast
    }, errorCallBack: (ResponseOb<dynamic> resp) {
      resp.message = MsgState.error; // Update message state on error
      resp.errState = ErrState.internetError; // Example error state
      profileController.sink.add(resp as ResponseOb<ProfileOb>); // Explicit cast
    });
  }

  // Fetch user posts
  Future<void> getPost() async {
    getReq(USER_POST_URL, onDataCallBack: (ResponseOb<dynamic> resp) {
      if (resp.data['success'] == true) {
        resp.data = ProfileResponsePostOb.fromJson(resp.data).result; // List<ProfilePostOb>
        resp.message = MsgState.data; // Update message state
      } else {
        resp.message = MsgState.error; // Handle error case
        resp.errState = ErrState.serverError; // Update error state
      }
      // Cast resp to ResponseOb<List<BlogOb>>
      blogController.sink.add(resp as ResponseOb<List<BlogOb>>); // Explicit cast
    }, errorCallBack: (ResponseOb<dynamic> resp) {
      resp.message = MsgState.error; // Update message state on error
      resp.errState = ErrState.internetError; // Example error state
      blogController.sink.add(resp as ResponseOb<List<BlogOb>>); // Explicit cast
    });
  }

  // Dispose of the stream controllers
  void dispose() {
    blogController.close();
    profileController.close();
  }
}
