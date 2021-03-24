import 'dart:convert';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/leavelists/leave_application.dart';
import 'package:AYT_Attendence/pages/homepage.dart';
import 'package:AYT_Attendence/sidebar/bottom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AYT_Attendence/Screens/leavelists/model/TrackLeaveModel.dart';

class MyTrackLeave extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyTrackLeave> {
  String unique_id2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      unique_id2 = sharedPreferences.getString("unique_id");
    });
  }

  Future<TrackLeaveModel> loadStudent() async {
    //var endpointUrl ="http://adiyogitechnosoft.com/attendance_dev/api/leave/NODS5X5N5V2H2Z";
    var endpointUrl =
        All_API().baseurl + All_API().api_apply_leave + unique_id2;
    print("NotificationUrl--> " + endpointUrl);
    try {
      var response = await http.get(endpointUrl, headers: {
        All_API().key: All_API().keyvalue,
      });
      print("TrackLeaveResponse--> " + response.body);
      var jasonDataNotification = jsonDecode(response.body);
      var msg=jasonDataNotification['msg'];
      if(response.statusCode==200){

        return TrackLeaveModel.fromJson(jasonDataNotification);
      }
      else{
        final snackBar = SnackBar(content: Text(msg,style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
        );
      }
    } catch (Exception) {
      return Exception;
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue[1000],
          title: Container(
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
            child: Text(
              'Track Leave',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          'Your Leaves',
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: RaisedButton(
                            child: Row(
                              children: [Icon(Icons.add), Text('APPLY')],
                            ),
                            color: Colors.blue[1000],
                            textColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue[1000])),
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            splashColor: Colors.blue[2000],
                            onPressed: () {
                              //onpressed gets called when the button is tapped.
                              print("FlatButton tapped");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LeaveApplication()));
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder<TrackLeaveModel>(
                  future: loadStudent(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.data.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var notificationlist = snapshot.data.data[index];
                            var strFrom = notificationlist.fromDate.toString();
                            var StrdateFrom = strFrom.split(" ");
                            var dateFrom = StrdateFrom[0].trim();
                            /////
                            var strTo = notificationlist.toDate.toString();
                            var StrdateTo = strTo.split(" ");
                            var dateTo = StrdateTo[0].trim();
                            return Card(
                              elevation: 8.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[1000],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0),
                                      // topRight: Radius.circular(10.0),
                                      // bottomRight: Radius.circular(10.0),
                                      // topLeft: Radius.circular(10.0),
                                      // bottomLeft: Radius.circular(10.0),
                                          ),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 5, left: 5, bottom: 5, right: 5),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),

                                  title: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      notificationlist.name,
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.amber),
                                          children: [
                                            TextSpan(
                                              text: '$dateFrom',
                                            ),
                                            WidgetSpan(
                                              child: Icon(
                                                  Icons.arrow_right_sharp,
                                                  color: Colors.white),
                                            ),
                                            TextSpan(
                                              text: '$dateTo',
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  // trailing:
                                  //  Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 30.0)),
                                ),
                              ),
                            );
                          });
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
