import 'dart:convert';
import 'package:my_clinic/screens/home/index.dart';
import 'package:flutter/material.dart';
import 'package:my_clinic/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(Wrapper());

class Wrapper extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  bool manager = false;
  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  void checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    Map<String, dynamic> user = jsonDecode(localStorage.getString('user'));
    if(token != null){
      setState(() {
        isAuth = true;
        if(isAuth){
          if(user['role'] == 'manager'){
            manager = true;
          }else{
            manager = false;
          }
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      if(manager){
        child = Index();
      }else{
        child = Index();
      }
    } else {
      child = Login();
    }
    return Scaffold(
      body: child,
    );
  }
}