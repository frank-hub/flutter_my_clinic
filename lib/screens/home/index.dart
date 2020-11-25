
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clinic/network_utils/api.dart';
import 'package:my_clinic/screens/auth/login.dart';
import 'package:my_clinic/screens/consultation/chats.dart';
import 'package:my_clinic/screens/health_tips.dart';
import 'package:my_clinic/screens/my_appointment.dart';
import 'package:my_clinic/screens/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  var name;
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
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => Index()));
              },
              child: _createDrawerItem(icon: Icons.local_hospital_rounded, text: 'Dashboard',),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: _createDrawerItem(icon: Icons.calendar_today_sharp,text: 'My Appointment',
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> MyAppointment()));
              }),
            ),
            _createDrawerItem(icon: Icons.live_help_outlined, text: 'Health Tips',
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HealthTips()));
            }),
            Divider(),
            _createDrawerItem(icon: Icons.chat, text:'Consultation',onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Chats()));
            }),
            _createDrawerItem(icon: Icons.calendar_today_outlined, text: 'Reminder',onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Reminder()));
            }),
            GestureDetector(
              child: _createDrawerItem(icon: Icons.account_box, text: 'Logout'),
              onTap: (){
                logout();
              },
            ),
            Divider(),
            // _createDrawerItem(icon: Icons.account_circle_outlined, text: 'Profile'),
            ListTile(
              title: Text('0.0.1'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//              height: 200,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Total Events',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),),
                        Text('269K',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),),
                      ],
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.blue, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 56, height: 56, child: Icon(Icons.show_chart,color: Colors.white,)),
                          onTap: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 170,
//                  width: 150,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.teal,
                            child: InkWell(
                              splashColor: Colors.red,
                              child: SizedBox(width: 56,height: 56 ,child:
                              Icon(Icons.add_shopping_cart,color: Colors.white,)),
                              onTap: (){},
                            ),
                          ),
                        ),
                        Text('Package',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),),
                        Text('Total Events',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),),


                      ],
                    ),
                  ),

                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 170,
//                  width: 150,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.yellow,
                            child: InkWell(
                              splashColor: Colors.red,
                              child: SizedBox(width: 56,height: 56 ,child:
                              Icon(Icons.notifications_active,color: Colors.white,)),
                              onTap: (){},
                            ),
                          ),
                        ),
                        Text('Notification',
                          style: TextStyle(
                            fontSize:27,
                            fontWeight: FontWeight.bold,
                          ),),
                        Text('All',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),),


                      ],
                    ),
                  ),

                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 220,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Coming Soon',
                      style: TextStyle(
                        fontSize:27,
                        fontWeight: FontWeight.bold,
                      ),),
                    Text('Reports',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),),
                    Text('Mpesa Transaction',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),),
                    Text('Subscription',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),),

                  ],
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }

  void logout() async{
    var res = await Network().getData('/logout');
    Map<String, dynamic> body = json.decode(res.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Login()
      ));
    }
  }
  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:  AssetImage('lib/assets/drawer.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Row(
                children: [
                  // Text("My Clinic",
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 20.0,
                  //         fontWeight: FontWeight.w500)),
                  Text( name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500)),
                ],
              )),
        ]));
  }
}



Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}


