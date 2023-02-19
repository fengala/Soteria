import 'package:flutter/material.dart';
import 'package:flutter_login_ui/home/test.dart';

import 'auth/login.dart';

class wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return either home or auth widget
    return login();
  }
}