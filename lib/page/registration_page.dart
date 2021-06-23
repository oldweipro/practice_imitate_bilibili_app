import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/util/string_util.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/login_button.dart';
import 'package:bilibili/widget/login_effect.dart';
import 'package:bilibili/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;

  const RegistrationPage({Key key, this.onJumpToLogin}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protected = false;
  bool loginEnable = false;
  String username;
  String password;
  String rePassword;
  String userId;
  String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', widget.onJumpToLogin),
      body: Container(
        child: ListView(
          //自适应
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
              lineStretch: true,
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
            LoginInput(
              '确认密码',
              '请再次输入密码',
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protected = focus;
                });
              },
            ),
            LoginInput(
              '用户ID',
              '请输入用户ID',
              lineStretch: true,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                userId = text;
                checkInput();
              },
            ),
            LoginInput(
              '订单号',
              '请输入订单号后四位',
              lineStretch: true,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                '注册',
                enable: loginEnable,
                onPressed: checkParams,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable = false;
    if (isNotEmpty(username) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(userId) &&
        isNotEmpty(orderId)) {
      enable = true;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
        } else {
          print('登录状态false');
        }
      },
      child: Text('注册'),
    );
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(username, password, userId, orderId);
      if (result['code'] == 0) {
        print('注册成功');
        showToast("注册成功");
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin();
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

  void checkParams() {
    String tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId.length != 4) {
      tips = '请输入订单号后四位';
    }
    if (tips != null) {
      print(tips);
      return;
    }
    send();
  }
}
