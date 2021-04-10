import 'dart:io';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/track_expenses.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
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
  FocusNode focusNode = new FocusNode();
  ProgressDialog pr;
  File image;
  var leaveID;
  TextEditingController _textEditingControllerPrice = TextEditingController();
  TextEditingController _textEditingControllerMSg = TextEditingController();
  TextEditingController _textEditingControllerDATE = TextEditingController();
  var expensesPrice;
  var expensesMSG;
  var ExpensesType;
  var expensesDate;
  DateTime currentDate = DateTime.now();
  ServiceStatus serviceStatus;

  String selectedvalue;
  List<dynamic> ExpensesTypeList = List();
  int leaveIndex = -1;
  List<Widget> list = null;
  final _formKey = GlobalKey<FormState>();

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
        expensesPrice +
        " " +
        expensesMSG +
        " " +
        expensesDate);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    final file = await http.MultipartFile.fromPath('image[]', image.path);
    request.fields['employee_id'] = uniqID;
    request.fields['expense_id'] = leaveID;
    request.fields['type'] = ExpensesType;
    request.fields['value'] = expensesPrice;
    request.fields['description'] = expensesMSG;
    request.fields['date'] = expensesDate;
    request.files.add(file);
    request.headers.addAll(headers);

    try{
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
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
      home: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text('Expenses Form',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
              backgroundColor: Colors.blue[1000],
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
                                child: Text('Type of Expenses',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                child: DropdownButton(
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
                              ),

                              new ListTile(
                                leading: const Icon(Icons.attach_money_outlined),
                                title: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _textEditingControllerPrice,
                                  decoration: new InputDecoration(
                                    hintText: "Expenses Price",
                                    labelText: ExpensesType!=null?ExpensesType.toString().toUpperCase():"Price",
                                    labelStyle: TextStyle(color: Colors.black,),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please fill Expenses Price';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              new ListTile(
                                leading: const Icon(Icons.article),
                                title: new TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _textEditingControllerMSg,
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
                                    controller: _textEditingControllerDATE,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      labelText: "Expenses Date",
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
                                      _textEditingControllerDATE.text = dateFrom;
                                    },
                                    validator: ((value){
                                      if(value.isEmpty){
                                        return 'Please fill Expenses Date';
                                      }
                                      return null;
                                    }),
                                  )
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        RaisedButton(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                          child: CircleAvatar(
                                            backgroundImage: image == null
                                                ? NetworkImage(
                                                'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                                                : FileImage(File(image.path)),
                                            radius: 50.0,
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20),
                                  child: RaisedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 35),
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
                                        //uploadmultipleimage();
                                        expensesDate = _textEditingControllerDATE.text;
                                        expensesPrice = _textEditingControllerPrice.text;
                                        expensesMSG = _textEditingControllerMSg.text;
                                        print("MSG-->"+expensesMSG);
                                        print("Price-->"+expensesPrice);
                                        print("Date--->"+expensesDate);
                                        /*print("Expenses--->"+selectedvalue);
                                          print("Type--->"+ExpensesType);*/
                                        print("Image--->"+image.toString());
                                        if (_formKey.currentState.validate()) {
                                          // If the form is valid, display a Snackbar.
                                          if(selectedvalue!=null ){
                                            _startUploading(context);
                                            // Scaffold.of(context)
                                            //     .showSnackBar(SnackBar(content: Text('Data is in processing.')));
                                          }else{
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(content: Text(
                                                'Select Type Of Expenses')));
                                            // messageAllert("Select Type Of Expenses", "Expenses Type");
                                          }
                                          // Scaffold.of(context)
                                          //     .showSnackBar(SnackBar(content: Text('Data is in processing.')));
                                        }
                                      })
                              ),
                            ],
                          ),
                        )
                    )
                )
            )
        ),
      ),
    );
  }

  void pickImages() async {
    var imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imagePicker;
      //Navigator.pop(context);
    });
  }
  void _startUploading(BuildContext context) async {

    if (image != null) {
      final Map<String, dynamic> response = await uploadmultipleimage();

      // Check if any error occured
      if (response == null) {
        pr.hide();
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(
            'Expenses Upload Successful')));
      }
    } else {
      pr.hide();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(
        'Select Image Of Expenses',style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.green,));
    }
  }
  void _resetState() {
    setState(() {
      pr.hide();
      image = null;
      expensesDate = null;
      selectedvalue = null;
      expensesMSG = null;
      expensesPrice = null;
    });
  }
}