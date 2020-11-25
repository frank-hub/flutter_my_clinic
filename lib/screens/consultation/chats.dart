import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clinic/Model/Chat.dart';
import 'package:http/http.dart' as http;
import 'package:my_clinic/screens/consultation/consult.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
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
        title: const Text('Consultation'),
      ),
      body: Center(
        child: Flexible(
          child: FutureBuilder<List<Chat>>(
            future: _fetchJobs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Chat> data = snapshot.data;
                return _jobsListView(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Consult()));
        },
        child: Icon(Icons.chat),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
  Future<List<Chat>> _fetchJobs() async {

    final jobsListAPIUrl = 'http://myclinic.horebinsurance.co.ke/api/v1/all_chats';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Chat.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Events from API');
    }
  }
  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _gestureDetector(data[index].name, data[index].sender,data[index].message,data[index].created_at);
        });

  }

  GestureDetector _gestureDetector(String name,String sender ,String message,String created_at) => GestureDetector(
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.chat
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Builder(
                        builder: (context) {
                            return Card(
                              color: Colors.green[600],
                              child: Text(sender,
                                style: TextStyle(
                                  letterSpacing: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                            );
                        }
                    )
                ),
                Text(
                  message,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  created_at,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

