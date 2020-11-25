import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:my_clinic/network_utils/api.dart';
import 'package:my_clinic/screens/consultation/chats.dart';
import 'package:my_clinic/screens/my_appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Consult extends StatefulWidget {
  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<Consult> {
  bool _isLoading = false;
  final _key = GlobalKey<FormState>();
  var name , message;
  @override
  void initState(){
    _loadUserData();
    super.initState();
  }
  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
//    var user = localStorage.getString('user');

    Map<String, dynamic> user = jsonDecode(localStorage.getString('user'));


    if(user != null) {
      setState(() {
        name = user['name'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Room'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Column(
            children: [
             Text(
               name,
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 15,
                 letterSpacing: 1.2,
               ),
             ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: "Describe Illness",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                validator: (messageValue) {
                  if (messageValue.isEmpty) {
                    return 'Please enter message';
                  }
                  message = messageValue;
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 10),
                    child: Text(
                      _isLoading? 'Proccessing...' : 'Consult',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  color: Colors.blue,
                  disabledColor: Colors.grey,
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                      new BorderRadius.circular(20.0)),
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      _book();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _book() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'name' : name,
      'message' : message,
      'sender' : 'Any Doctor',
    };
    var res = await Network().authData(data, '/chat_store');
    var body = await json.decode(res.body);
    // Map<String, dynamic> body = await json.decode(res.body);
    print(data);
    if(body['success']){

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Chats()
        ),
      );
    }else{
//      print(body['message']);
//      _showMsg(body['message']);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
