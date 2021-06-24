import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/util/string_util.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/login_button.dart';
import 'package:bilibili/widget/login_effect.dart';
import 'package:bilibili/widget/login_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onJumpRegistration;
  final VoidCallback onSuccess;

  const LoginPage({Key key, this.onJumpRegistration, this.onSuccess})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protected = false;
  bool loginEnable = false;
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', widget.onJumpRegistration),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protected),
            LoginInput(
              '用户名',
              '请输入用户名',
              onChanged: (text) {
                username = text;
                checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protected = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: LoginButton(
                '登录',
                enable: loginEnable,
                onPressed: send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable = false;
    if (isNotEmpty(username) && isNotEmpty(password)) {
      enable = true;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(username, password);
      if (result['code'] == 0) {
        print('登录成功');
        showToast('登录成功');
        if (widget.onSuccess != null) {
          widget.onSuccess();
        }
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
