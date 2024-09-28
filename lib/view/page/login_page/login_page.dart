import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/utils/app_utils.dart';
import 'package:blog_tuto_ap/view/page/home_page/home_page.dart';
import 'package:blog_tuto_ap/view/page/regsiter_page/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTec = TextEditingController();
  final passwordTec = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _bloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _bloc.loginStream().listen((ResponseOb resp) {
      if (resp.message == MsgState.data) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return HomePage();
          }),
              (route) => false,
        );
      }
      if (resp.message == MsgState.error) {
        String errorMessage = resp.errState == ErrState.userErr
            ? resp.data.toString()
            : "Something went wrong!";
        AppUtils.showSnackBar(context, errorMessage); // Updated to use context
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80),
            FlutterLogo(size: 100),
            SizedBox(height: 80),
            _buildTextField(emailTec, "Enter Email"),
            SizedBox(height: 20),
            _buildTextField(passwordTec, "Enter Password", isObscure: true),
            SizedBox(height: 30),
            AppUtils.loadingWidget(
              stream: _bloc.loginStream(),
              widget: _buildLoginButton(),
            ),
            SizedBox(height: 20),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isObscure = false}) {
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
        obscureText: isObscure,
      ),
    );
  }

  Widget _buildLoginButton() {
    return NeumorphicButton(
      onPressed: checkLogin,
      child: Center(
        child: Text(
          "Login",
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

  Widget _buildRegisterButton() {
    return NeumorphicButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterPage();
        }));
      },
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

  void checkLogin() {
    if (emailTec.text.isEmpty || passwordTec.text.isEmpty) {
      AppUtils.showSnackBar(context, "Fill all fields"); // Use context here
      return;
    }

    Map<String, String> map = {
      'email': emailTec.text,
      'password': passwordTec.text,
    };

    _bloc.login(map);
  }

  @override
  void dispose() {
    emailTec.dispose(); // Dispose of the controller
    passwordTec.dispose(); // Dispose of the controller
    _bloc.dispose();
    super.dispose();
  }
}
