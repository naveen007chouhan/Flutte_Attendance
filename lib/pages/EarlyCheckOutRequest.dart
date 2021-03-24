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
  _EarlyCheckOutRequestState createState() => _EarlyCheckOutRequestState();
}

class _EarlyCheckOutRequestState extends State<EarlyCheckOutRequest> {
  String unique_id2;

  @override
  void initState(){
    super.initState();
    getData();
  }

  getData()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      unique_id2=sharedPreferences.getString("unique_id");
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
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //int status2= int.parse(snapshot.data.status);
                int status2= snapshot.data.status;
                return ExpansionCard(
                  title: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 5.0, color: Colors.red))),
                        child: Image.asset("assets/rejected_ap.png",height: 60,width: 50,fit: BoxFit.contain,),
                      ),
                      title: Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.date_range_rounded , color: Colors.black),
                            ),
                            Text(snapshot.data.date,style: TextStyle(fontSize:17,color: Colors.black54,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      trailing:
                      Icon(Icons.keyboard_arrow_right_rounded, color: Colors.red, size: 30.0)),
                );
                /*status2==1?Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)
                        // topRight: Radius.circular(10.0),
                        // bottomRight: Radius.circular(10.0),
                        // topLeft: Radius.circular(10.0),
                        // bottomLeft: Radius.circular(10.0),
                      ),
                    ),

                    margin:const EdgeInsets.only(top: 5,left: 5,bottom: 5,right: 5),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(width: 5.0, color: Colors.blue))),
                          child: Image.asset("assets/pending_ap.png",height: 60,width: 50,fit: BoxFit.contain,),
                        ),
                        *//*leading: Container(
                                        // padding: EdgeInsets.only(right: 12.0),
                                        // decoration: new BoxDecoration(
                                        //     border: new Border(
                                        //         right: new BorderSide(width: 5.0, color: Colors.red))),
                                        // margin: const EdgeInsets.all(10.0),
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                             color: Colors.black,  // red as border color
                                           ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),

                                        ),
                                        // decoration: BoxDecoration(
                                        //   border: Border.all(
                                        //     color: Colors.blue,  // red as border color
                                        //   ),
                                        // ),
                                        child: Text("Pending",style: TextStyle(
                                          inherit: true,
                                          fontSize: 16.0,
                                          color: Colors.black,

                                        ),),
                                      ),*//*

                        title: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "EXPENSE : "+notificationlist.expenseName.toUpperCase(),
                            style: TextStyle(fontSize:15,color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text("Price : "+"Rs "+notificationlist.price,style: TextStyle(fontSize:15,color: Colors.black54),),
                                *//*Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                              ),*//*
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(Icons.date_range_rounded , color: Colors.black),
                                      ),
                                      Text("$date",style: TextStyle(fontSize:17,color: Colors.black54,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    child:Icon(Icons.edit,color: Colors.black54,size: 30,),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateExpensesApplication(
                                        id: notificationlist.id,
                                        date: notificationlist.date.toString(),
                                        employeeID:notificationlist.employeeId,
                                        image: path+notificationlist.image,
                                        expenseID: notificationlist.expenseId,
                                        expenseType: notificationlist.type,
                                        expenseValue: notificationlist.km,
                                        description: notificationlist.description,
                                        expenseName: notificationlist.expenseName,
                                      )));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing:
                        Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 30.0)),

                  ),
                ):
                Card(
                  // color: Colors.green,
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)
                        // topRight: Radius.circular(10.0),
                        // bottomRight: Radius.circular(10.0),
                        // topLeft: Radius.circular(10.0),
                        // bottomLeft: Radius.circular(10.0),
                      ),
                    ),

                    margin:const EdgeInsets.only(top: 5,left: 5,bottom: 5,right: 5),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(width: 5.0, color: Colors.green))),
                          child: Image.asset("assets/approved_ap.png",height: 60,width: 50,fit: BoxFit.contain,),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "EXPENSE : "+notificationlist.expenseName.toUpperCase(),
                            style: TextStyle(fontSize:15,color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text("Price : "+"Rs "+notificationlist.price,style: TextStyle(fontSize:15,color: Colors.black54),),
                                *//*Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                              ),*//*
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(Icons.date_range_rounded , color: Colors.black),
                                      ),
                                      Text("$date",style: TextStyle(fontSize:17,color: Colors.black54,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        trailing:
                        Icon(Icons.keyboard_arrow_right_rounded, color: Colors.green, size: 30.0)),

                  ),
                );*/
              } else
                return Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[1000],
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EarlyCheckOutUpload()));
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
    var endpointUrl =
        All_API().baseurl + All_API().api_mark_early +"/"+unique_id2;
    print("Mark Early--> " + endpointUrl);
    var response = await http.get(endpointUrl, headers: {
      All_API().key: All_API().keyvalue,
    });
    var jasonDataNotification = jsonDecode(response.body);
    String msg=jasonDataNotification['msg'];
    print("Mark Early Response--> " + response.body);
    if (response.statusCode == 200) {
      _showToast(context, msg);
      return EarlyCheckInOutModel.fromJson(jasonDataNotification);

    }
    else{
      _showToast(context, msg);
    }
  }
  void _showToast(BuildContext context,String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(""),
        behavior:SnackBarBehavior.floating ,
        action: SnackBarAction(
            label: msg!=null?msg:"",
            textColor: Colors.white, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}