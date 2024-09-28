import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';


enum RequestType {
  Get,
  Post
}
class BaseNetwork {
  void getReq(String url, {Map<String, String>? params, void Function(ResponseOb)? onDataCallBack, void Function(ResponseOb)? errorCallBack}) async {
    requestData(RequestType.Get, url: url, params: params, onDataCallBack: onDataCallBack, errorCallBack: errorCallBack);
  }

  void postReq(String url, {Map<String, String>? params, FormData? fd, void Function(ResponseOb)? onDataCallBack, void Function(ResponseOb)? errorCallBack}) async {
    requestData(RequestType.Post, url: url, params: params, fd: fd, onDataCallBack: onDataCallBack, errorCallBack: errorCallBack);
  }

  void requestData(RequestType rt, {@required required String url, Map<String, String>? params, FormData? fd, void Function(ResponseOb)? onDataCallBack, void Function(ResponseOb)? errorCallBack}) async {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    );

    String? token = await SharedPref.getData(key: SharedPref.token);
    options.headers = {
      'Authorization': token,
    };

    Dio dio = Dio(options);

    try {
      Response response;
      if (rt == RequestType.Get) {
        response = await dio.get(url, queryParameters: params ?? {});
      } else {
        response = await dio.post(url, data: fd ?? params ?? {});
      }

      int statusCode = response.statusCode ?? 0;
      ResponseOb respOb = ResponseOb();

      print('*************\n');
      print('Request URL: $url');
      print('Status Code: $statusCode');
      print('Response Data: ${response.data}');
      print('*************\n');

      if (statusCode == 200) {
        if (response.data['success'] == true) {
          respOb.data = response.data;
          respOb.message = MsgState.data;
          onDataCallBack?.call(respOb);
        } else {
          respOb.data = response.data['result'];
          respOb.message = MsgState.error;
          respOb.errState = ErrState.userErr;
          errorCallBack?.call(respOb);
        }
      } else {
        respOb.errState = ErrState.serverError;
        respOb.message = MsgState.error;
        errorCallBack?.call(respOb);
      }
    } on DioError catch (e) {
      print('DioError: $e');
      ResponseOb respOb = ResponseOb();
      respOb.errState = ErrState.serverError;
      respOb.message = MsgState.error;
      respOb.data = e.response?.data;
      errorCallBack?.call(respOb);
    } catch (e) {
      print('General error: $e');
      ResponseOb respOb = ResponseOb();
      respOb.errState = ErrState.serverError;
      respOb.message = MsgState.error;
      errorCallBack?.call(respOb);
    }
  }
}
