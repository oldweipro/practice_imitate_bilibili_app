import 'package:bilibili/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          //自适应
          children: [
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
            )
          ],
        ),
      ),
    );
  }
}
