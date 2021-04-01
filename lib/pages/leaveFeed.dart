import 'dart:convert';
import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/model/LeaveModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class leaveFeed extends StatefulWidget {
  leaveFeed({this.unique_id});
  final String unique_id;
  @override
  _leaveFeedState createState() => _leaveFeedState();
}

class _leaveFeedState extends State<leaveFeed> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<LeaveModelData> loadStudent() async {
    print("UNIQ ID Leave--->" + widget.unique_id);
    //await wait(5);
    var endpointUrl =
        All_API().baseurl + All_API().api_leave_type + widget.unique_id;
    //print("LeavesendpointUrl -->"+All_API().baseurl+All_API().api_leave_type+widget.unique_id);
    print('LeavesendpointUrl : ' + endpointUrl);
    Map<String, String> headers = {
      All_API().key: All_API().keyvalue,
    };

    var response = await http.get(endpointUrl, headers: headers);

    Map jasonData = jsonDecode(response.body);
    print('Leaves : ' + jasonData.toString());
    return new LeaveModelData.fromJson(jasonData);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      child:Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 0,
          child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text('Leave Feed',
              style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,
                  color: Colors.blue[1000]),
            ),),

            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(flex: 8,child: FutureBuilder<LeaveModelData>(
          future: loadStudent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var article = snapshot.data.data[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // Expanded(flex:2,child: ),
                        // Expanded(flex:2,child: )

                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            border: Border.all(
                              color: Colors.orange, // red as border color
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white54,
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0),
                              BoxShadow(
                                  color: Colors.white60,
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0)
                            ],
                          ),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              article.totalUsed.toString(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(
                                                "USED",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: new EdgeInsets.all(8.0),
                                          width: screenSize.width * 0.3,
                                          child: Row(
                                            children: [
                                              Text(
                                                article.leaveType,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: Center(
                                                        child: Text(
                                                          article.totalAllowd,
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        )),
                                                  ),
                                                  Center(
                                                      child: Text(
                                                        "ALLOWED",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasData == false) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Expanded(flex:2,child: ),
                  // Expanded(flex:2,child: )

                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: 5.0),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(
                        color: Colors.orange, // red as border color
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white54,
                            offset: Offset(0, 5),
                            blurRadius: 10.0),
                        BoxShadow(
                            color: Colors.white60,
                            offset: Offset(0, 5),
                            blurRadius: 10.0)
                      ],
                    ),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "USED",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: new EdgeInsets.all(8.0),
                                    width: screenSize.width * 0.3,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Paid Leave",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                            ),
                                            Center(
                                                child: Text(
                                                  "ALLOWED",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),),
        SizedBox(
          height: 10,
        ),
      ],
    ),);
  }
}
