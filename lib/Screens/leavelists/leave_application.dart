import 'dart:convert';
import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/expenses_application.dart';
import 'package:AYT_Attendence/Screens/leavelists/model/TrackLeaveModel.dart';
import 'package:AYT_Attendence/Screens/leavelists/track_leave.dart';
import 'package:AYT_Attendence/model/LeaveModel.dart';
import 'package:AYT_Attendence/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LeaveApplication extends StatefulWidget {
  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}
class LeaveApplicationWidgetState extends State<LeaveApplication>
    with SingleTickerProviderStateMixin {
  String dayLeave=null;
  var dayLeaveID;
  List<dynamic> ExpensesTypeList = List();
  List DayTypeList=[{'id':'1','name':'half day'},{'id':'0','name':'no selected'}];
  var leaveID;
  String selectedvalue;
  final _formKey = GlobalKey<FormState>();
  String name;
  String date;
  String uniqID;
  String employeeID;
  String latitude;
  String longitude;
  String action;
  String address;
  String device;
  String action_check;
  FocusNode focusNode = new FocusNode();
  String checkINmsg;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  getData()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      name=sharedPreferences.getString("name");
      uniqID=sharedPreferences.getString("unique_id");
      employeeID=sharedPreferences.getString("user_unique_id");
      latitude=sharedPreferences.getString("lat");
      longitude=sharedPreferences.getString("long");
      action=sharedPreferences.getString("");
      address=sharedPreferences.getString("address");
      device=sharedPreferences.getString("device_id");
      print("UNIQ ID Dasboad--->"+uniqID);
      loadStudent(uniqID);
    });
  }
  TextEditingController _textEditingControllerMSG = TextEditingController();
  TextEditingController _textEditingControllerFromDate = TextEditingController();
  TextEditingController _textEditingControllerToDate = TextEditingController();
  var msg;
  DateTime currentDate = DateTime.now();
  var dateFrom;
  var dateTo;
  ProgressDialog pr;
  void sendLeave(BuildContext context) async {
    setState(() {
      pr.show();
    });
    String url = All_API().baseurl +All_API().api_apply_leave;
    print("leave_urlbody--> " + url);
    String body =jsonEncode({
      "employee_id": uniqID,
      "leave_type_id": leaveID,
      "from_date":dateFrom ,"to_date": dateTo==null?dateFrom:dateTo,
      "reason": msg,"half_day": "0"});
    print("leave_body--> " + body);
    Map<String, String> headers = {
      All_API().key: All_API().keyvalue,
    };
    final http.Response response = await http.post(url,body:body,headers: headers);
    Map<String,dynamic> jasonData = jsonDecode(response.body);
    String bodydetial = response.body;
    String statusCode = response.statusCode.toString();
    print("bodyss--> " + bodydetial.toString()+"  ///  "+statusCode);
    checkINmsg=jasonData["msg"];
    if (response.statusCode == 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            'Leave Request Successfully!!'),
        backgroundColor: Colors.green,
      )
      );
      pr.hide();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content:
      Text(
          'Leave Request UnSuccessful'),
        backgroundColor: Colors.red,
      ));
      pr.hide();
    }
  }
  Future loadStudent(String uniqID) async {
    //var endpointUrl ="http://adiyogitechnosoft.com/attendance_dev/api/leave/NODS5X5N5V2H2Z";
    var endpointUrl = All_API().baseurl + All_API().api_leave_spinner + uniqID  ;
    print("ExpensesUrl--> " + endpointUrl);
    var response = await http.get(endpointUrl, headers: {
      All_API().key: All_API().keyvalue,
    });
    print("ExpensesResponse--> " + response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jasonDataNotification = jsonDecode(response.body);
      setState(() {
        ExpensesTypeList = jasonDataNotification['data'];
      });
    } else {}
    print("ExpensesTypeList-->" + ExpensesTypeList.toString());
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Leave Application',style: TextStyle(color: Colors.orange)),
            backgroundColor: Colors.blue[1000],
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios,color: Colors.orange,),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Builder(
                      builder: (context) => Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('Day Leave',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text("Select Leave day",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                value: dayLeave,
                                items: DayTypeList.map((explist) {
                                  return DropdownMenuItem(
                                    value: explist['name'],
                                    child: Text(explist['name']),
                                    onTap: (){
                                      dayLeaveID = explist['id'];
                                      print("leavess-->"+explist['id']);
                                    },
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dayLeave = value;
                                    if(dayLeaveID==0){
                                      dayLeave = null;
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('Type of Leave',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text("Select Leave",style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                                value: selectedvalue,
                                items: ExpensesTypeList.map((explist) {
                                  return DropdownMenuItem(
                                    value: explist['leave_type'],
                                    child: Text(explist['leave_type']),
                                    onTap: (){
                                      leaveID=explist['leave_id'];
                                      print("leavess-->"+leaveID.toString());
                                    },
                                  );
                                }).toList(),
                                onChanged:(value) {
                                  setState(() {
                                    selectedvalue=value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            new ListTile(
                              leading: const Icon(Icons.article),
                              title: new TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _textEditingControllerMSG,
                                decoration: new InputDecoration(
                                  hintText: "Expenses Description",
                                  labelText: "Description",
                                  labelStyle: TextStyle(color: Colors.black,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please fill Expenses Description';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            new ListTile(
                                leading: const Icon(Icons.calendar_today),
                                title: TextFormField(
                                  controller: _textEditingControllerFromDate,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    labelText: "From Date",
                                    hintText: "Date",),
                                  onTap: () async{
                                    DateTime date = DateTime(1900);
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    date = await showDatePicker(
                                        context: context,
                                        initialDate:DateTime.now(),
                                        firstDate:DateTime(1900),
                                        lastDate: DateTime(2100));
                                    currentDate = date;
                                    var str = currentDate.toString();
                                    var Strdate = str.split(" ");
                                    var dateFrom1 = Strdate[0].trim();
                                    dateFrom =_textEditingControllerFromDate.text = dateFrom1;
                                  },
                                  validator: ((value){
                                    if(value.isEmpty){
                                      return 'Please fill Expenses Date';
                                    }
                                    return null;
                                  }),
                                )
                            ),
                            SizedBox(height: 10,),
                            dayLeave == 'no selected'?Visibility(
                              visible: true,
                              child: new ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: TextFormField(
                                    controller: _textEditingControllerToDate,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      labelText: "To Date",
                                      hintText: "Date",),
                                    onTap: () async{
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      date = await showDatePicker(
                                          context: context,
                                          initialDate:DateTime.now(),
                                          firstDate:DateTime(1900),
                                          lastDate: DateTime(2100));
                                      currentDate = date;
                                      var str = currentDate.toString();
                                      var Strdate = str.split(" ");
                                      var dateFrom = Strdate[0].trim();
                                      dateTo = _textEditingControllerToDate.text = dateFrom;
                                    },
                                    validator: ((value){
                                      if(value.isEmpty){
                                        return 'Please fill Expenses Date';
                                      }
                                      return null;
                                    }),
                                  )
                              ),
                            )
                                :Visibility(
                              visible: false,
                              child: new ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: TextFormField(
                                    controller: _textEditingControllerToDate,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      labelText: "To Date",
                                      hintText: "Date",),
                                    onTap: () async{
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      date = await showDatePicker(
                                          context: context,
                                          initialDate:DateTime.now(),
                                          firstDate:DateTime(1900),
                                          lastDate: DateTime(2100));
                                      currentDate = date;
                                      var str = currentDate.toString();
                                      var Strdate = str.split(" ");
                                      var dateFrom = Strdate[0].trim();
                                      dateTo = _textEditingControllerToDate.text = dateFrom;
                                    },
                                    validator: ((value){
                                      if(value.isEmpty){
                                        return 'Please fill Expenses Date';
                                      }
                                      return null;
                                    }),
                                  )
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20),
                                child: RaisedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 80),
                                      child: Text(
                                        "APPLY LEAVE",
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    color: Colors.orange,
                                    hoverColor: Colors.blue[1000],
                                    hoverElevation: 40.0,
                                    onPressed: () {
                                      msg = _textEditingControllerMSG.text;
                                      if (_formKey.currentState.validate() && selectedvalue!=null) {
                                        // If the form is valid, display a Snackbar.
                                        sendLeave(context);
                                      }else{
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(content: Text(
                                            'Please Fill All Fields!')));
                                        // messageAllert("Select Type Of Expenses", "Expenses Type");
                                      }
                                      // Scaffold.of(context)
                                      //     .showSnackBar(SnackBar(content: Text('Data is in processing.')));
                                    }
                                )
                            ),
                          ],
                        ),
                      )
                  )
              )
          )
      ),
    );
  }
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child: Text("Manager Details")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("From Date $dateFrom"),
              Text("To Date $dateTo"),
              Text("Half $dayLeave"),
              Text("MSG $msg"),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

