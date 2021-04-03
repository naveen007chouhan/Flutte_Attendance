import 'dart:convert';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/model/GeneralLeaveModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class GeneralLeave extends StatefulWidget {
  @override
  _GeneralLeaveState createState() => _GeneralLeaveState();
}

class _GeneralLeaveState extends State<GeneralLeave> {
  var StatusCode;

  Future<GeneralLeaveModel> loadStudent() async {
    var endpointUrl = All_API().baseurl + All_API().api_general_leaves;
    Map<String, String> headers = {
      All_API().key: All_API().keyvalue,
    };
    Map<String, String> queryParameter = {
      'status': '1',
    };
    String queryString = Uri(queryParameters: queryParameter).query;
    var requestUrl = endpointUrl + '?' + queryString;
    print("GeneralLeave_URl--> " + requestUrl);
    var response = await http.get(requestUrl, headers: headers);
    var jasonData = jsonDecode(response.body);
    var msg = jasonData['msg'];
    StatusCode = response.statusCode;
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //     msg: msg,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return GeneralLeaveModel.fromJson(jasonData);
    } else {
      // Fluttertoast.showToast(
      //     msg: msg,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
    print('General : ' + jasonData.toString());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Text(
              'General Leave',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[1000],
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  width: mediaQuery.size.width * 0.50,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Date",style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.center,),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black38,
                      ),

                      //Text(formattedDate,style: TextStyle(fontSize: 17,color: Colors.black54,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.black38,
                ),
                Container(
                  width: mediaQuery.size.width * 0.50,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Name",style: TextStyle(fontSize: 20,color: Colors.black),),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black38,
                      ),

                      //Text(article.name,style: TextStyle(fontSize: 17,color: Colors.black54,),textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder<GeneralLeaveModel>(
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
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var article = snapshot.data.data[index];
                            print("check--> "+article.name);
                            var date = DateTime.parse(article.date);
                            var formattedDate = "${date.day}-${date.month}-${date.year}";
                            print (formattedDate);
                            return Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: mediaQuery.size.width * 0.50,
                                    child: Column(
                                      children: [
                                        Padding(padding:  EdgeInsets.all(8.0)),
                                        Text(formattedDate,style: TextStyle(fontSize: 17,color: Colors.black54,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                        Padding(padding:  EdgeInsets.all(8.0)),
                                        Divider(
                                          height: 1,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 0,
                                    color: Colors.black38,
                                  ),
                                  Container(
                                    width: mediaQuery.size.width * 0.50,
                                    child: Column(
                                      children: [
                                        Padding(padding:  EdgeInsets.all(8.0)),
                                        Text(article.name,style: TextStyle(fontSize: 17,color: Colors.black54,),textAlign: TextAlign.center,),
                                        Padding(padding:  EdgeInsets.all(8.0)),
                                        Divider(
                                          height: 1,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }else{
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
              },
            ),
          ],
        )
    );

  }
}
