import 'dart:async';
import 'dart:convert';

import 'package:AYT_Attendence/API/api.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class checkIN_OUT extends StatefulWidget {
  @override
  checkIN_OUTState createState() => checkIN_OUTState();
}

class checkIN_OUTState extends State<checkIN_OUT> {
  String name;
  String date;
  String uniqID;
  String latitude;
  String longitude;
  String action;
  String address;
  String device;
  String action_check;
  String result = "Hey there !";

  String attendanceTimeCheckIN;
  String attendanceTimeCheckOut;
  String checkINmsg;

  @override
  void initState() {
    date = DateFormat("yyyy/MM/dd HH:mm:ss").format(DateTime.now());
    print(date); //
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString("name");
      uniqID = sharedPreferences.getString("unique_id");
      latitude = sharedPreferences.getString("lat");
      longitude = sharedPreferences.getString("long");
      action = sharedPreferences.getString("");
      address = sharedPreferences.getString("address");
      device = sharedPreferences.getString("device");
      attendanceTimeCheckIN = sharedPreferences.getString("checkin_time");
      attendanceTimeCheckOut = sharedPreferences.getString("checkout_time");
    });
  }

  var statusCode;
  void chech_in_out(String action) async {
    String url = All_API().baseurl + All_API().api_attendance;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String body = jsonEncode({
      "id": uniqID,
      "current_date": date,
      "latitute": latitude,
      "longitute": longitude,
      "area": address,
      "device": device,
      "qr_code": result,
      "action": action
    });
    print("phone_body--> " + body);

    Map<String, String> headers = {
      All_API().key: All_API().keyvalue,
    };
    final http.Response response =
        await http.post(url, body: body, headers: headers);
    Map<String, dynamic> jasonData = jsonDecode(response.body);

    print("Response :---->" + jasonData.toString());
    checkINmsg = jasonData["msg"];
    statusCode = response.statusCode;
    if (response.statusCode == 200) {
      setState(() {
        startTimer();
        checkINmsg = jasonData["msg"];
        attendanceTimeCheckIN = jasonData["checkin_time"];
        attendanceTimeCheckOut = jasonData["checkout_time"];
        sharedPreferences.setString("checkin_time", attendanceTimeCheckIN);
        sharedPreferences.setString("checkout_time", attendanceTimeCheckOut);
        print("Data Attendance : " + jasonData["msg"]);
        print("Data Attendance : " + jasonData["checkin_time"]);
        print("Data Attendance : " + jasonData["checkout_time"]);
        final snackBar = SnackBar(
          content: Text(
            checkINmsg,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      final snackBar = SnackBar(
        content: Text(
          checkINmsg,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future _scanQR(String action1) async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        print(result);
        chech_in_out(action1);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
          print(result);
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
          print(result);
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
        print(result);
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
        print(result);
      });
    }
  }

  Timer timer;
  int second = 0;
  int timeHour;
  int timeMinuts;
  int timeSecond;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (attendanceTimeCheckIN != 'Pending') {
          second++;
          setState(() {
            timeHour = (second / 3600).truncate();
            timeMinuts = (second % 3600 / 60).truncate();
            timeSecond = (second % 60).truncate();
          });
        } else if (attendanceTimeCheckOut != 'Pending') {
          second;
          setState(() {
            timeHour = (second / 3600).truncate();
            timeMinuts = (second % 3600 / 60).truncate();
            timeSecond = (second % 60).truncate();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Woring Hour's : ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              timeHour==null?"00 :":timeHour.toString() + ':',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              timeMinuts ==null?" 00 :":timeMinuts.toString() + ':',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              timeSecond ==null?" 00 ":timeSecond.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ////Check IN
            Expanded(
              flex: 4,
              child:Card(
                child: Container(
                  height: 100, //10 for example
                  margin:const EdgeInsets.only(top: 5,left: 5,bottom: 5,right: 5),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    /*boxShadow: [
                      BoxShadow(
                          color: Colors.green[200],
                          offset: Offset(0, 10),
                          blurRadius: 10.0),
                      BoxShadow(
                          color: Colors.green[100],
                          offset: Offset(0, 10),
                          blurRadius: 10.0)
                    ],*/
                  ), //10 for example
                  child: InkWell(
                    onTap: () {
                      print("Check Out Clicked");
                      _scanQR("checkin");
                    },
                    child: Row(
                      children: [
                        Container(
                            height: 100,
                            width: 60,
                            child: Image.asset(
                              'assets/check_in.png',
                              height: 40,
                              width: 40,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 0, bottom: 0),
                          child: Column(
                            children: [
                              Text('CHECK IN',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[1000])),
                              statusCode == 200
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(attendanceTimeCheckIN,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[1000])),
                              )
                                  : Text("Pending",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[1000])),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ),
            /////Check OUT
            Expanded(
              flex: 4,
              child:Card(
                child: Container(
                  height: 100, //10 for example
                  margin:const EdgeInsets.only(top: 5,left: 5,bottom: 5,right: 5),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    /*boxShadow: [
                      BoxShadow(
                          color: Colors.red[200],
                          offset: Offset(0, 10),
                          blurRadius: 10.0),
                      BoxShadow(
                          color: Colors.red[100],
                          offset: Offset(0, 10),
                          blurRadius: 10.0)
                    ],*/
                  ), //10 for //10 for example
                  child: InkWell(
                    onTap: () {
                      print("Check Out Clicked");
                      _scanQR("checkout");
                    },
                    child: Row(
                      children: [
                        Container(
                            height: 100,
                            width: 60,
                            child: Image.asset(
                              'assets/check_out.png',
                              height: 40,
                              width: 40,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 0, bottom: 0),
                          child: Column(
                            children: [
                              Text('CHECK OUT',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[1000])),
                              statusCode == 200
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(attendanceTimeCheckOut,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[1000])),
                              )
                                  : Text("Pending",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[1000])),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            )
          ],
        ),
      ],
    );
  }


}
