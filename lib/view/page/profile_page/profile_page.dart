import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:blog_tuto_ap/view/page/login_page/login_page.dart';
import 'package:blog_tuto_ap/view/widget/post_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'profile_bloc.dart';
import 'profile_ob.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getProfile();
    _bloc.getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: NeumorphicAppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<ResponseOb>(
              stream: _bloc.profileStream(),
              initialData: ResponseOb(message: MsgState.loading),
              builder: (context, snapshot) {
                final resp = snapshot.data; // Nullable handling

                if (resp?.message == MsgState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (resp?.message == MsgState.error) {
                  return Center(child: Text("Something went wrong, try again!"));
                } else if (resp?.data is ProfileOb) { // Check type safely
                  ProfileOb po = resp!.data; // Non-null assertion
                  return Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      depth: 8,
                    ),
                    child: Container(
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: 8,
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                imageUrl: IMG_BASE_URL + (po.image ?? ''), // Ensure image is non-null
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            po.name ?? 'Unknown', // Ensure name is non-null
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            po.email ?? 'Unknown', // Ensure email is non-null
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          NeumorphicButton(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            onPressed: logout,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.exit_to_app),
                                Text("Logout"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text("Invalid data received."));
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              "Your Post",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder<ResponseOb>(
              initialData: ResponseOb(message: MsgState.loading),
              stream: _bloc.blogStream(),
              builder: (context, snapshot) {
                final resp = snapshot.data; // Nullable handling
                if (resp?.message == MsgState.data) {
                  List<BlogOb> list = resp?.data;
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: list.map((ob) {
                      return PostWidget(ob);
                    }).toList(),
                  );
                } else if (resp?.message == MsgState.error) {
                  return Center(child: Text("Something went wrong"));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void logout() {
    SharedPref.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
