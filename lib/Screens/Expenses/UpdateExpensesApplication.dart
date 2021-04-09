import 'dart:io';

import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/track_expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PermissionHandler permissionHandler = PermissionHandler();

class UpdateExpensesApplication extends StatefulWidget {
  String id;
  String date;
  String employeeID;
  String image;
  String expenseID;
  String expenseType;
  String expenseValue;
  String description;
  String expenseName;

  UpdateExpensesApplication(
      {
        this.id,
        this.date,
        this.employeeID,
        this.image,
        this.expenseID,
        this.expenseType,
        this.expenseValue,
        this.description,
        this.expenseName,
      });
  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}

class LeaveApplicationWidgetState extends State<UpdateExpensesApplication>
    with SingleTickerProviderStateMixin {

  File image;
  var leaveID;
  bool isChecked = false;
  var labels;
  var msg;
  var kmvalue;
  var ExpensesType;
  ProgressDialog pr;
  TextEditingController _ExpPriceController = TextEditingController();
  TextEditingController _ExpMsgController2 = TextEditingController();

  DateTime currentDate = DateTime.now();
  var dateFrom;
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

  @override
  void initState() {
    super.initState();
    ExpensesStudent();
    var str=widget.date;
    var Strdate=str.split(" ");
    var date = Strdate[0].trim();
    dateFrom = date;
    leaveID = widget.expenseID;
    msg = widget.description;
    kmvalue = widget.expenseValue;
    ExpensesType = widget.expenseType;
    selectedvalue = widget.expenseName;
  }

  Future uploadmultipleimage() async {
    setState(() {
      pr.show();
    });
    var url = All_API().baseurl + All_API().api_update_expense;
    print("Employee Update URL--->"+url);
    print("Employee ID--->"+widget.employeeID);

    Map<String, String> headers = {
      All_API().key: All_API().keyvalue,
      'Content-Type': 'multipart/form-data'
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.files.add(await http.MultipartFile.fromPath('image[]', image.path));
    final file = await http.MultipartFile.fromPath('image[]', image.path);
    request.fields['id'] = widget.id;
    request.fields['employee_id'] = widget.employeeID;
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
      print("Update_Expenses---> : " + response.body);
      String mssg = responseData['msg'];
      if (response.statusCode == 200) {
        print("if Expenses---> : Your Expenses Uploaded " + mssg);
        return null;

      } else {
        print("else Expenses---> : Your Expenses Not Uploaded");
        pr.hide();
        messageAllert(mssg, 'Fail');
        print(response.reasonPhrase);
      }
      _resetState();
      return responseData;
    }catch(e){
      return(e);
    }
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    //   return null;
    // } else {
    //   print(response.reasonPhrase);
    // }
  }

  ServiceStatus serviceStatus;

  String selectedvalue;
  List<dynamic> ExpensesTypeList = List();
  Future ExpensesStudent() async {
    serviceStatus =
    await PermissionHandler().checkServiceStatus(PermissionGroup.storage);
    var endpointUrl = All_API().baseurl + All_API().api_type_expense_list;
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

  String _errorMessage;
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
            title: Text('Expenses Update ',style: TextStyle(color: Colors.orange),),
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
                                                    : "",
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
                                  child: Text('Type of Expenses',style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                                ),
                                Column(
                                  children: <Widget>[
                                    DropdownButton(
                                      isExpanded: true,
                                      hint: Text(selectedvalue!=null?selectedvalue:"Select Expenses",style: TextStyle(
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
                                  decoration: new InputDecoration(
                                    hintText: kmvalue!=null?kmvalue:'Enter Value',
                                    labelText: "Expenses Price: "+ExpensesType!=null?ExpensesType:'Expenses Price',
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
                                    hintText: msg!=null?msg:'Enter Description',
                                    labelText: msg != null
                                        ? msg
                                        :"Description",
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
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Row(
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
                                              })
                                        ],
                                      ),
                                      //Image.file(image)
                                      widget.image!=null?Image.network(widget.image,fit: BoxFit.fill,height: 100,width: 200,):NetworkImage(
                                          'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png'),
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
                                            style: TextStyle(
                                                color: Colors.white),
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

                                        })),
                              ])))))),
    );
  }



  Future<void> pickImages() async {
    /*List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: imagesList,
        materialOptions: MaterialOptions(
          actionBarTitle: "AYT ATTENDANCE",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      imagesList = resultList;
      //print("Selected Images---> " + imagesList.join(All_API().baseurl_img));
    });*/
    //File image;
    var imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imagePicker;
    });
  }
  void startUploading() async {
    print("_startUploading -------> " + msg);
    if (image != null  ) {
      final Map<String, dynamic> response = await uploadmultipleimage();

      //Check if any error occured
      if (response == null) {
        pr.hide();
        messageAllert('Record save Successfully..', 'Success');
      }
    } else {
      pr.hide();
      messageAllert(' Please Select a profile photo ', ' Select Photo ');
    }
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
                  setState(() {
                    //You can also make changes to your state here.

                  });
                  Navigator.pop(context);

                },
              ),
            ],
          );
        });
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
}