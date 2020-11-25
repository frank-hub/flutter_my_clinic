import 'dart:convert';
import 'dart:io';
import 'package:my_clinic/screens/home/index.dart';
import 'package:flutter/material.dart';
import 'package:my_clinic/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_clinic/screens/auth/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}
enum SingingCharacter { Public, Manager  }

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  SingingCharacter _character = SingingCharacter.Public;
  var email;
  var password;
  var name;
  // ignore: non_constant_identifier_names
  var person_role;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Item selectedUser;
  List<Item> users = <Item>[
    const Item('Public',Icon(Icons.people,color:  const Color(0xFF167F67),)),
    const Item('Event Manager',Icon(Icons.verified_user,color:  const Color(0xFF167F67),)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                            child: Image.asset('lib/assets/myclinic.png')
                        ),
                        Card(
                          elevation: 4.0,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  TextFormField(
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Email",
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
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.insert_emoticon,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Username",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (username) {
                                      if (username.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      name = username;
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (passwordValue) {
                                      if (passwordValue.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      password = passwordValue;
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
                                          _isLoading? 'Proccessing...' : 'Register',
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
                                        if (_formKey.currentState.validate()) {
                                          _register();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              'Already Have an Account',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 15.0,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _register()async{
    setState(() {
      _isLoading = true;
    });

//    String userMap = jsonDecode(_character);

    var data = {
      'email' : email,
      'password': password,
      'role': 'patient',
      'name': name,
    };
//    exit(selectedUser);

    var res = await Network().authData(data, '/register');
    Map<String, dynamic> body = json.decode(res.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Index()
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