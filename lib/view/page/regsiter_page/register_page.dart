import 'dart:io';

import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/utils/app_utils.dart';
import 'package:blog_tuto_ap/view/page/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import 'register_bloc.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _file; // Nullable file for the selected image
  final emailTec = TextEditingController();
  final nameTec = TextEditingController();
  final passwordTec = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _bloc = RegisterBloc();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _bloc.registerStream().listen((ResponseOb resp) {
      if (resp.message == MsgState.data) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return HomePage();
          }),
              (route) => false,
        );
      }
      if (resp.message == MsgState.error) {
        AppUtils.showSnackBar(context, "Something went wrong!"); // Ensure context is passed first
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: NeumorphicAppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            _buildImagePicker(),
            SizedBox(height: 50),
            _buildTextField(nameTec, "Enter Name"),
            SizedBox(height: 20),
            _buildTextField(emailTec, "Enter Email"),
            SizedBox(height: 20),
            _buildTextField(passwordTec, "Enter Password", obscureText: true),
            SizedBox(height: 20),
            AppUtils.loadingWidget(
              stream: _bloc.registerStream(),
              widget: _buildRegisterButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return NeumorphicButton(
      onPressed: pickImage,
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.circle(),
        depth: 8,
        lightSource: LightSource.topLeft,
      ),
      child: Container(
        width: 100,
        height: 100,
        child: _file != null
            ? Image.file(_file!, fit: BoxFit.cover)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person),
            Text("Upload\nPhoto", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool obscureText = false}) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: -4,
        lightSource: LightSource.topLeft,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10),
        ),
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return NeumorphicButton(
      onPressed: checkRegister,
      child: Center(
        child: Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _file = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void checkRegister() async {
    if (emailTec.text.isEmpty || passwordTec.text.isEmpty || nameTec.text.isEmpty) {
      AppUtils.showSnackBar(context, "Fill Data"); // Ensure context is passed first
      return;
    }
    if (_file == null) {
      AppUtils.showSnackBar(context, "Select Image"); // Ensure context is passed first
      return;
    }

    Map<String, dynamic> map = {
      'email': emailTec.text,
      'password': passwordTec.text,
      'name': nameTec.text,
    };

    _bloc.register(map, _file!); // Use _file! here
  }

  @override
  void dispose() {
    emailTec.dispose();
    nameTec.dispose();
    passwordTec.dispose();
    _bloc.dispose();
    super.dispose();
  }
}
