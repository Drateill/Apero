import 'package:Apero/screens/authenticate/authenticate.dart';
import 'package:Apero/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Apero/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    // Home or Auth 
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}