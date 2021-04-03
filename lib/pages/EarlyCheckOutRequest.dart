import 'dart:convert';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/model/EarlyCheck_IN_OUT_Model.dart';
import 'package:flutter/material.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'EarlyCheckOutUpload.dart';

class EarlyCheckOutRequest extends StatefulWidget {
  @override
  EarlyCheckOutRequestState createState() => EarlyCheckOutRequestState();
}

class EarlyCheckOutRequestState extends State<EarlyCheckOutRequest> {
  String unique_id2;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      unique_id2 = sharedPreferences.getString("unique_id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[1000],
          title: Container(
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
            child: Text(
              'Early CheckOut List',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
        body: FutureBuilder<EarlyCheckInOutModel>(
            future: earlyMarkMethod(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        int status2 = int.parse(snapshot.data.data[index].status);
                        var list = snapshot.data.data[index];
                        var dateSplit = list.date.split(' ').toList();
                        var date = dateSplit[0].trim();
                        return
                            status2 == 0
                            ? Card(
                          elevation: 8,
                          child: ExpansionCard(
                            title: Container(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 8.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 5.0,
                                                color: Colors.red))),
                                    child: Image.asset(
                                      "assets/rejected_ap.png",
                                      height: 70,
                                      width: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(padding: EdgeInsets.all(4.0),
                                      child:Text(
                                        "Date : "+date,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400),
                                      ),)

                                    ],
                                  ),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7),
                                child: Text(list.reasion,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black,fontWeight: FontWeight.w400)),
                              )
                            ],
                          ),
                        )
                            : status2 == 1
                            ? Card(
                          elevation: 8,
                          child: ExpansionCard(
                            title: Container(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 8.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 5.0,
                                                color: Colors.blue))),
                                    child: Image.asset(
                                      "assets/pending_ap.png",
                                      height: 70,
                                      width: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Row(
                                    children: [

                                      Padding(padding: EdgeInsets.all(4.0),
                                        child :Text(
                                        "Date : "+date,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                                child: Text(list.reasion,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,fontWeight: FontWeight.w400)),
                              )
                            ],
                          ),
                        )
                            : status2 == 2
                            ? Card(
                          elevation: 8,
                          child: ExpansionCard(
                            title: Container(
                              child: Row(
                                children: [
                                  Container(
                                    padding:
                                    EdgeInsets.only(right: 8.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 5.0,
                                                color: Colors.green))),
                                    child: Image.asset(
                                      "assets/approved_ap.png",
                                      height: 70,
                                      width: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        "Date : "+date,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54,
                                            fontWeight:
                                            FontWeight.w400),
                                      ),),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 7,vertical: 5),
                                child: Text(list.reasion,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w400)),
                              )
                            ],
                          ),
                        )
                            : Card(
                          elevation: 8,
                          child: ExpansionCard(
                            title: Container(
                              child: Row(
                                children: [
                                  Container(
                                    padding:
                                    EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 5.0,
                                                color: Colors.red))),
                                    child: Image.asset(
                                      "assets/ayt.png",
                                      height: 60,
                                      width: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Row(
                                    children: [

                                      Text(
                                        "Date : "+date,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 7),
                                child: Text(list.reasion,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black)),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else
                    return Center(
                      child: Card(
                        color: Colors.blue[1000],
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            All_API().two_error_occurred,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
              }

            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[1000],
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EarlyCheckOutUpload()));
          },
          tooltip: "Add Early Checkout",
          child: Icon(
            Icons.add,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }

  Future<EarlyCheckInOutModel> earlyMarkMethod() async {
    var endpointUrl = All_API().baseurl + All_API().api_mark_early;
    Map<String, String> queryParameter = {
      'id': unique_id2,
    };
    String queryString = Uri(queryParameters: queryParameter).query;
    var requestUrl = endpointUrl + '?' + queryString;

    var response = await http.get(requestUrl, headers: {
      All_API().key: All_API().keyvalue,
    });
    print("Mark Early URL---> " + requestUrl);
    print("Mark Early Status Code--> " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var jasonDataNotification = jsonDecode(response.body);
      String msg = jasonDataNotification['msg'];
      //_showToast(context, msg);
      print("Mark Early Response--> " + response.body);
      return EarlyCheckInOutModel.fromJson(jasonDataNotification);
    } else {
      //_showToast(context, msg);
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(""),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            label: msg != null ? msg : "",
            textColor: Colors.white,
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
