import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/model/user.dart';
import 'package:swap/page/home/home.dart';
import 'package:swap/page/login/login.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);

    if (user != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
