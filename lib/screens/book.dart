import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:my_clinic/network_utils/api.dart';
import 'package:my_clinic/screens/my_appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  bool _isLoading = false;
  final _key = GlobalKey<FormState>();
  var name , email ,phone ,illness,start;
  DateTime selectedDate;
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
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                validator: (emailValue) {
                  if (emailValue.isEmpty) {
                    return 'Please enter email';
                  }
                  email = emailValue;
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: name,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                validator: (nameValue) {
                  if (nameValue.isEmpty) {
                    return 'Please enter Name';
                  }
                  name = nameValue;
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone No.",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                validator: (phoneValue) {
                  if (phoneValue.isEmpty) {
                    return 'Please enter phone no.';
                  }
                  phone = phoneValue;
                  return null;
                },
              ),
              DateTimeField(
                selectedDate: selectedDate,

                onDateSelected: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                firstDate: DateTime.now(),
                lastDate: DateTime(2022),
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
                validator: (illnessValue) {
                  if (illnessValue.isEmpty) {
                    return 'Please enter description';
                  }
                  illness = illnessValue;
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
                      _isLoading? 'Proccessing...' : 'Book Appointment',
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
      'phone' : phone,
      'email' : email,
      'illness' : illness,
      'start' : selectedDate.toIso8601String(),
    };
    var res = await Network().authData(data, '/book');
    var body = await json.decode(res.body);
    // Map<String, dynamic> body = await json.decode(res.body);
    print(data);
    if(body['success']){

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MyAppointment()
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
