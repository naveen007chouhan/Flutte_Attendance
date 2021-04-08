import 'dart:io';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/track_expenses.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

final PermissionHandler permissionHandler = PermissionHandler();

class ExpensesApplication extends StatefulWidget {
  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}

class LeaveApplicationWidgetState extends State<ExpensesApplication>
    with SingleTickerProviderStateMixin {
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
  ProgressDialog pr;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    ExpensesStudent();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString("name");
      uniqID = sharedPreferences.getString("unique_id");
      employeeID = sharedPreferences.getString("user_unique_id");
      latitude = sharedPreferences.getString("lat");
      longitude = sharedPreferences.getString("long");
      action = sharedPreferences.getString("");
      address = sharedPreferences.getString("address");
      device = sharedPreferences.getString("device_id");
      print("UNIQ ID Dasboad--->" + uniqID);
    });
  }

  //List<Asset> imagesList = List<Asset>();
  File image;
  var leaveID;
  var labels;
  TextEditingController _ExpPriceController = TextEditingController();
  TextEditingController _ExpMsgController2 = TextEditingController();
  var msg = null;
  var kmvalue;
  var ExpensesType;

  DateTime currentDate = DateTime.now();
  String dateFrom;
  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        var str = currentDate.toString();
        var Strdate = str.split(" ");
        dateFrom = Strdate[0].trim();
      });
  }

  Future uploadmultipleimage() async {
    setState(() {
      pr.show();
    });
    var url = All_API().baseurl + All_API().api_upload_expense;
    print("uploadExpenses url -------> " +url);
    Map<String, String> headers = {
      All_API().key: All_API().keyvalue,
      'Content-Type': 'multipart/form-data'
    };
    //String imageMulti=image.path.split('/image_picker').last;
    //String path=All_API().baseurl_img+'/uploads/employee/';
    print("Path Image -------> " +
        uniqID +
        " " +
        leaveID +
        " " +
        ExpensesType +
        " " +
        kmvalue +
        " " +
        msg +
        " " +
        dateFrom);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    final file = await http.MultipartFile.fromPath('image[]', image.path);
    request.fields['employee_id'] = uniqID;
    request.fields['expense_id'] = leaveID;
    request.fields['type'] = ExpensesType;
    request.fields['value'] = kmvalue;
    request.fields['description'] = msg;
    request.fields['date'] = dateFrom;
    request.files.add(file);
    request.headers.addAll(headers);

    try{
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      // http.StreamedResponse response = await request.send();
      // var resopnss = await http.Response.fromStream(response);
      // var jsonData = jsonDecode(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      print("Expenses---> : " + response.body);
      String mssg = responseData['msg'];
      if (response.statusCode == 200) {
        print("if Expenses---> : Your Expenses Uploaded " + mssg);
        return null;

      } else {
        print("else Expenses---> : Your Expenses Not Uploaded");
        print(response.reasonPhrase);
      }
      _resetState();
      return responseData;
    }catch(e){
      return(e);
    }

  }

  ServiceStatus serviceStatus;

  String selectedvalue;
  List<dynamic> ExpensesTypeList = List();
  Future ExpensesStudent() async {
    serviceStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.storage);
    // print("label you selected-->"+labels+" "+isChecked.toString());
    var endpointUrl = All_API().baseurl + All_API().api_type_expense_list;
    //"NODS5X5N5V2H2Z";
    //print("ExpensesUrl--> " + endpointUrl);
    Map<String, String> queryParameter = {
      'status': '1',
    };
    String queryString = Uri(queryParameters: queryParameter).query;
    var requestUrl = endpointUrl + '?' + queryString;
    print("requestUrl--> " + requestUrl);

    var response = await http.get(requestUrl, headers: {
      All_API().key.toUpperCase(): All_API().keyvalue.toUpperCase(),
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
    //============================================= loading dialoge
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
            title: Text('Expenses Form',
                style: TextStyle(
                  color: Colors.orange,
                )),
            backgroundColor: Colors.blue[1000],
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                color: Colors.orange,
              ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Choose Date',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
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
                                                              dateFrom != null
                                                                  ? dateFrom
                                                                  : "Select Date",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
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
                                          )),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text('Type of Expenses',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Column(
                                  children: <Widget>[
                                    DropdownButton(
                                      isExpanded: true,
                                      hint: Text("Select Expenses",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      value: selectedvalue,
                                      items: ExpensesTypeList.map((explist) {
                                        return DropdownMenuItem(
                                          value: explist['name'],
                                          child: Text(explist['name']),
                                          onTap: () {
                                            ExpensesType = explist['type'];
                                            leaveID = explist['id'];
                                            print(ExpensesType);
                                          },
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedvalue = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                TextField(
                                  autofocus: false,
                                  controller: _ExpPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: ExpensesType != null
                                        ? ExpensesType
                                        : "Expenses Price ",
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
                                TextField(
                                  autofocus: false,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  controller: _ExpMsgController2,

                                  decoration: new InputDecoration(
                                    labelText: "Description",
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
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 170,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          RaisedButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 16.0),
                                                child: Text(
                                                  "Choose Images",
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                              ),
                                              color: Colors.blue[1000],
                                              hoverColor: Colors.blue[1000],
                                              hoverElevation: 40.0,
                                              onPressed: () {
                                                pickImages();
                                              }),
                                          CircleAvatar(
                                            backgroundImage: image == null
                                                ? NetworkImage(
                                                'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                                                : FileImage(image),
                                            radius: 60.0,
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 16.0),
                                    child: RaisedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0, horizontal: 16.0),
                                          child: Text(
                                            "APPLY EXPENSES",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        color: Colors.orange,
                                        hoverColor: Colors.blue[1000],
                                        hoverElevation: 40.0,
                                        onPressed: () {
                                          if(_ExpPriceController.text.isNotEmpty&&_ExpMsgController2.text.isNotEmpty&&dateFrom!=null&&selectedvalue!=null){
                                            msg = _ExpMsgController2.text;
                                            kmvalue = _ExpPriceController.text;
                                            startUploading();
                                          }else{
                                            messageAllert(' Please Fill All Detail ', ' Form Not Submited ');
                                          }

                                          //uploadmultipleimage();
                                        })),
                              ])))))),
    );
  }



  void pickImages() async {

    var imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imagePicker;
      //Navigator.pop(context);
    });
  }

  void startUploading() async {
    print("_startUploading -------> " + msg);
    if (image != null  ) {
      final Map<String, dynamic> response = await uploadmultipleimage();

      //Check if any error occured
      if (response == null) {
        pr.hide();
        messageAllert('User details updated successfully', 'Success');
      }
    } else {
      pr.hide();
      messageAllert(' Please Select a profile photo ', ' Select Photo ');
    }
  }
  void _resetState() {
    setState(() {
      pr.hide();
      image = null;
      dateFrom = null;
      selectedvalue = null;
      msg = null;
      kmvalue = null;
    });
  }
  messageAllert(String msg, String ttl) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
