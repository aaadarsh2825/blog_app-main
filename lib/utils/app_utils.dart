import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';

class AppUtils {
  static void showSnackBar(
      BuildContext context, // Ensure context is the first parameter
      String title, {
        Color bgColor = Colors.red,
        Color textColor = Colors.white,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
        backgroundColor: bgColor,
      ),
    );
  }

  static Widget loadingWidget({
    required Stream<ResponseOb> stream,
    required Widget widget,
  }) {
    return StreamBuilder<ResponseOb>(
      initialData: ResponseOb(),
      stream: stream,
      builder: (context, snapshot) {
        ResponseOb resp = snapshot.data ?? ResponseOb();
        if (resp.message == MsgState.loading) {
          return Center(
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.circle(),
                depth: -3,
              ),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return widget;
        }
      },
    );
  }
}
