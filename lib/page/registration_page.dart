import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/login_effect.dart';
import 'package:bilibili/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', () {
        print('右侧点击');
      }),
      body: Container(
        child: ListView(
          //自适应
          children: [
            LoginEffect(protected),
            LoginInput(
              '用户名',
              '请输入用户名',
              onChanged: (text) {
                print(text);
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                print(text);
              },
              focusChanged: (focus) {
                this.setState(() {
                  protected = focus;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
