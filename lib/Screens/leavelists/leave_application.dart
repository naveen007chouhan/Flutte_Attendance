import 'dart:convert';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/expenses_application.dart';
import 'package:AYT_Attendence/Screens/leavelists/model/TrackLeaveModel.dart';
import 'package:AYT_Attendence/model/LeaveModel.dart';
import 'package:AYT_Attendence/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LeaveApplication extends StatefulWidget {
  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}

class LeaveApplicationWidgetState extends State<LeaveApplication>
    with SingleTickerProviderStateMixin {

  var half="Half Day";
  bool halfLeave=false;

  var leaveID;
  String selectedvalue;
  // ignore: deprecated_member_use
  List<dynamic> ExpensesTypeList = List();

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
    loadStudent();
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
    });
  }

  TextEditingController _textEditingController = TextEditingController();
  var msg;

  DateTime currentDate = DateTime.now();
  var dateFrom;
  var dateTo;
  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        var str=currentDate.toString();
        var Strdate=str.split(" ");
        dateFrom = Strdate[0].trim();

      });
  }
  Future<void> _selectDateTO(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        var str=currentDate.toString();
        var Strdate=str.split(" ");
        dateTo = Strdate[0].trim();

      });
  }

  void sendLeave() async {
    String url = All_API().baseurl +All_API().api_apply_leave;
    print("leave_urlbody--> " + url);
    String body =jsonEncode({
      "employee_id": employeeID,
      "leave_type_id": leaveID,
      "from_date":dateFrom ,"to_date": dateTo,
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
    _showToast(context,checkINmsg);
    final snackBar = SnackBar(content: Text('Leave Successfully Apply',style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    if (response.statusCode == 200) {
      // FocusScope.of(context).requestFocus(focusNode);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard()));
      setState(() {

      });
    } else {
      // FocusScope.of(context).requestFocus(focusNode);
      final snackBar = SnackBar(content: Text('Leave Not Successfully Apply',style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {

      });
    }
  }
  Future loadStudent() async {
    //var endpointUrl ="http://adiyogitechnosoft.com/attendance_dev/api/leave/NODS5X5N5V2H2Z";
    var endpointUrl = All_API().baseurl + All_API().api_leave_spinner +
        "NODS5X5N5V2H2Z";
    print("NotificationUrl--> " + endpointUrl);
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
  int leaveIndex = -1;
  List<Widget> list = null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
              body1: TextStyle(
                  color: Colors.black87,
                  fontFamily: "poppins-medium",
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400),
              button: TextStyle(
                  color: Colors.black87,
                  fontFamily: "poppins-medium",
                  fontSize: 18,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900))),
      home: Scaffold(
          // resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Leave Application'),
            backgroundColor: Colors.blue[1000],
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Builder(
                      builder: (context) => Form(
                        //key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Text(
                                    "Available Leaves",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: list == null
                                      ? LinearProgressIndicator()
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: list,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text('From'),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 20),
                                        child: RaisedButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0)),
                                          elevation: 4.0,
                                          onPressed: () {
                                            _selectDateFrom(context);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50.0,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            dateFrom!=null?dateFrom:"",
                                                            style: TextStyle(
                                                              color: Colors.blue,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                    Text('To'),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 20),
                                        child: RaisedButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0)),
                                          elevation: 4.0,
                                          onPressed: () {
                                            _selectDateTO(context);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50.0,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            dateTo!=null?dateTo:"",
                                                            style: TextStyle(
                                                                color: Colors.blue,
                                                                fontSize: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                CheckboxGroup(
                                  labels: <String>[
                                    half,
                                  ],
                                  //checked: _checked,
                                  activeColor: Colors.red,
                                  onChange: (bool isChecked, String label,
                                      int index) {
                                    print(
                                        "isChecked: $isChecked   label: $label  index: $index");
                                    leaveIndex = index;
                                    halfLeave=isChecked;
                                  },
                                  onSelected: (List selected) => setState(() {
                                    //isSelected = true;
                                    if (selected.length > 1) {
                                      selected.removeAt(0);
                                      print(
                                          'selected length  ${selected.length}');
                                    } else {
                                      print("only one");
                                    }
                                    //_checked = selected;
                                  }),
                                ),
                                Container(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text('Type of leave'),
                                ),
                                Column(
                                  children: <Widget>[
                                    DropdownButton(
                                      isExpanded: true,
                                      hint: Text("Select Expenses"),
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
                                  ],
                                ),
                                TextField(
                                  autofocus: false,
                                  controller: _textEditingController,
                                  onSubmitted: _giveData(_textEditingController),
                                  decoration: new InputDecoration(
                                    labelText:
                                    "Message for Management (Optional)",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black54),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black54),
                                    ),
                                  ),
                                ),

                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                    child: RaisedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0, horizontal: 16.0),
                                          child: Text("APPLY LEAVE",style: TextStyle(color: Colors.orange),),
                                        ),
                                        color: Colors.blue[1000],
                                        hoverColor: Colors.blue[1000],
                                        hoverElevation: 40.0,
                                        onPressed: () {

                                          msg=_textEditingController.text;
                                          sendLeave();
                                          _showDialog(context);
                                        }
                                    )
                                ),
                              ])
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
              Text("Half $half"),
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
  _giveData(TextEditingController textEditingController) {
    msg=_textEditingController.text;
  }
  void _showToast(BuildContext context,String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Have a nice Day"),
        behavior:SnackBarBehavior.floating ,
        action: SnackBarAction(
            label: msg!=null?msg:"",
            textColor: Colors.white, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}