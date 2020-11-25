import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clinic/Model/Booking.dart';
import 'package:my_clinic/screens/book.dart';
import 'package:http/http.dart' as http;
class MyAppointment extends StatefulWidget {
  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointment'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children:[

          Center(
            child: Flexible(
              child: FutureBuilder<List<Booking>>(
                future: _fetchJobs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Booking> data = snapshot.data;
                    return _jobsListView(data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => Book()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
  Future<List<Booking>> _fetchJobs() async {

    final jobsListAPIUrl = 'http://myclinic.horebinsurance.co.ke/api/v1/all_bookings';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Booking.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Events from API');
    }
  }
  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _gestureDetector(data[index].name, data[index].phone,data[index].illness,data[index].status);
        });

  }

  GestureDetector _gestureDetector(String name,String phone ,String illness,int status) => GestureDetector(
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(height: 100.0,width: 100.0,
              image: AssetImage('lib/assets/appointments.png'),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                name,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                  child: Builder(
                      builder: (context) {
                        if (status == 0) {
                          return Card(
                            color: Colors.lightBlue,
                            child: Text('Pending',
                            style: TextStyle(
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                            ),
                          );
                        } else {
                          return Card(
                            color: Colors.green[600],
                            child: Text('Approved',
                              style: TextStyle(
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      }
                  )
              ),
              Text(
                illness,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

