import 'dart:convert';
import 'dart:io';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/model/ExpensesGetModel.dart';
import 'package:AYT_Attendence/pages/ImageDetail.dart';
import 'package:AYT_Attendence/sidebar/bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateExpensesApplication.dart';
import 'expenses_application.dart';
import 'package:http/http.dart' as http;

class MyTrackExpenses extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyTrackExpenses> {
  String unique_id2;
  String user_unique_id;
  String type;
  String km;
  String price;
  String message;
  String img;
  String path;
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
      user_unique_id = sharedPreferences.getString("user_unique_id");
    });
  }

  Future<ExpensesGetModel> loadStudent() async {
    var endpointUrl =
        All_API().baseurl + All_API().api_expense_list + unique_id2;
    print("TrackExpensesUrl--> " + endpointUrl);

    try {
      var response = await http.get(endpointUrl, headers: {
        All_API().key: All_API().keyvalue,
      });
      print("TrackExpensesresponse--> " + response.body);
      if (response.statusCode == 200) {
        var jasonDataNotification = jsonDecode(response.body);
        return ExpensesGetModel.fromJson(jasonDataNotification);
      } else {
        // final snackBar = SnackBar(content: Text('No Record Found',style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.orange,);
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
        );*/
      }
    } catch (Exception) {
      return Exception;
    }
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
              'Expenses List',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          /*leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),*/
        ),
        body: FutureBuilder<ExpensesGetModel>(
            future: loadStudent(),
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
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        path = All_API().baseurl_img + snapshot.data.path;

                        var notificationlist = snapshot.data.data[index];
                        int status =
                            int.parse(snapshot.data.data[index].status);
                        var str = notificationlist.date.toString();
                        var Strdate = str.split(" ");
                        var date = Strdate[0].trim();
                        var time = Strdate[1].trim();
                        // img = notificationlist.image;
                        // print("img_URl--> "+img);
                        return GestureDetector(
                          onTap: () {
                            if (notificationlist.km != 0) {
                              type = notificationlist.expenseName;
                              km = notificationlist.km;
                              price = notificationlist.price;
                              message = notificationlist.description;
                              img = notificationlist.image;
                              _showDialog(
                                  context, type, km, price, message, img, path);
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                  'No Detail Expenses',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: status == 0
                              ? Card(
                                  // color: Colors.green,
                                  elevation: 8.0,
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)
                                          // topRight: Radius.circular(10.0),
                                          // bottomRight: Radius.circular(10.0),
                                          // topLeft: Radius.circular(10.0),
                                          // bottomLeft: Radius.circular(10.0),
                                          ),
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 5, left: 2, bottom: 5, right: 2),
                                    child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        leading: Container(
                                          padding: EdgeInsets.only(right: 5.0),
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
                                        title: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "EXPENSE : " +
                                                notificationlist.expenseName
                                                    .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0)),
                                                Text(
                                                  "Price : " +
                                                      "Rs " +
                                                      notificationlist.price,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54),
                                                ),
                                                /*Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                              ),*/
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Icon(
                                                            Icons
                                                                .date_range_rounded,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        "$date",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: Colors.black54,
                                            size: 30.0)),
                                  ),
                                )
                              : status == 1
                                  ? Card(
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)
                                              // topRight: Radius.circular(10.0),
                                              // bottomRight: Radius.circular(10.0),
                                              // topLeft: Radius.circular(10.0),
                                              // bottomLeft: Radius.circular(10.0),
                                              ),
                                        ),
                                        margin: const EdgeInsets.only(
                                            top: 5,
                                            left: 2,
                                            bottom: 5,
                                            right: 2),
                                          child:Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10.0),
                                                leading: Container(
                                                  padding:
                                                  EdgeInsets.only(right: 5.0),
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
                                                title: Padding(
                                                  padding:
                                                  const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "EXPENSE : " +
                                                        notificationlist.expenseName
                                                            .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.orange,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                            padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                        Text(
                                                          "Price : " +
                                                              "Rs " +
                                                              notificationlist
                                                                  .price,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black54,
                                                              fontWeight:
                                                              FontWeight.w200),
                                                        ),

                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                                child: Icon(
                                                                    Icons
                                                                        .date_range_rounded,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Text(
                                                                "$date",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                               /* trailing: Icon(
                                                    Icons
                                                        .keyboard_arrow_right_rounded,
                                                    color: Colors.white,
                                                    size: 30.0),*/

                                              ),
                                              ListTile(
                                                trailing: Container(
                                                  child: RaisedButton(
                                                    child: Text('Edit'),
                                                    color: Colors.orange,
                                                    textColor: Colors.white,
                                                    elevation: 5,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0),
                                                        side: BorderSide(color: Colors.blue[1000])
                                                    ),
                                                    // padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                                                    splashColor: Colors.blue[1000],
                                                    onPressed: (){Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                UpdateExpensesApplication(
                                                                  id: notificationlist.id,
                                                                  date:
                                                                  notificationlist.date.toString(),
                                                                  employeeID:
                                                                  notificationlist.employeeId,
                                                                  image:
                                                                  path + notificationlist.image,
                                                                  expenseID:
                                                                  notificationlist.expenseId,
                                                                  expenseType:
                                                                  notificationlist.type,
                                                                  expenseValue:
                                                                  notificationlist.km,
                                                                  description:
                                                                  notificationlist.description,
                                                                  expenseName:
                                                                  notificationlist.expenseName,
                                                                )));},
                                                  ),

                                                ),
                                              ),
                                            ],
                                          )


                                      ),

                                    )
                                  : Card(
                                      // color: Colors.green,
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        margin: const EdgeInsets.only(
                                            top: 5,
                                            left: 2,
                                            bottom: 5,
                                            right: 2),
                                        child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10.0),
                                            leading: Container(
                                              padding:
                                                  EdgeInsets.only(right: 5.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(
                                                          width: 5.0,
                                                          color:
                                                              Colors.green))),
                                              child: Image.asset(
                                                "assets/approved_ap.png",
                                                height: 70,
                                                width: 60,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                "EXPENSE : " +
                                                    notificationlist.expenseName
                                                        .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.orange,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                            subtitle: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Text(
                                                      "Price : " +
                                                          "Rs " +
                                                          notificationlist
                                                              .price,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w200),
                                                    ),
                                                    /*Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                              ),*/
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Icon(
                                                                Icons
                                                                    .date_range_rounded,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            "$date",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            trailing: Icon(
                                                Icons
                                                    .keyboard_arrow_right_rounded,
                                                color: Colors.black54,
                                                size: 30.0)),
                                      ),
                                    ),
                        );
                      },
                    );
                  } else {
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
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[1000],
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExpensesApplication()));
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
}

void _showDialog(context, String type, String km, String price, String message,
    String img, String path) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          "Expenses Detail ",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Type : " + type,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[1000])),
                ),
              ],
            ),
            Row(
              children: [
                Visibility( visible: km=='0'?true:false,child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Km : "+km,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[1000])),),

                ),

              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Price : " + price,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[1000])),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Message : " + message,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[1000])),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          Container(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: RaisedButton(
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageDetail(
                              imgDetail: img,
                              path: path,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Photos",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: RaisedButton(
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Close",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
