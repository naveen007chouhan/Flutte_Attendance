import 'dart:io';
import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/Screens/Expenses/track_expenses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  File image;
  var leaveID;
  bool isChecked = false;
  var labels;
  var expensesPrice;
  var expensesMSG;
  var ExpensesType;
  var expensesImage;
  TextEditingController _textEditingControllerPrice ;
  TextEditingController _textEditingControllerMSg ;
  TextEditingController _textEditingControllerDATE ;
  DateTime currentDate = DateTime.now();
  var expensesDate;
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    ExpensesStudent();
    var str=widget.date;
    var Strdate=str.split(" ");
    var date = Strdate[0].trim();
    expensesDate = date;
    leaveID = widget.expenseID;
    expensesMSG = widget.description;
    expensesPrice = widget.expenseValue;
    ExpensesType = widget.expenseType;
    selectedvalue = widget.expenseName;
    expensesImage = widget.image;
    print("expensesImage-->"+expensesImage);
    networkImageToBase64(expensesImage);
    _textEditingControllerPrice = TextEditingController(text: expensesPrice);
    _textEditingControllerMSg = TextEditingController(text: expensesMSG);
    _textEditingControllerDATE = TextEditingController(text: expensesDate);
  }
  void networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(imageUrl);
    //final bytes = response?.bodyBytes;
    var _base64 = base64Encode(response.bodyBytes);
    final decodedBytes = base64Decode(_base64);
    final Future<Directory> path = getApplicationDocumentsDirectory();
    final localPath = await path;
    print("local Path"+localPath.toString());
    var splitPath = localPath.path.split("'");
    print("local Path"+splitPath.first);
    //File('$localPath/$pngBytes');
    var fileImage="decodedBezkoder.png";
    image = File(splitPath.first+"/"+fileImage);
    image.writeAsBytesSync(decodedBytes);
    print("File Type Image--->"+image.toString());
    //return (bytes != null ? base64Encode(bytes) : null);
  }
  Future uploadmultipleimage(BuildContext context) async {
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
    request.fields['id'] = widget.id;
    request.fields['employee_id'] = widget.employeeID;
    request.fields['expense_id'] = leaveID;
    request.fields['type'] = ExpensesType;
    request.fields['value'] = expensesPrice;
    request.fields['description'] = expensesMSG;
    request.fields['date'] = expensesDate;
    request.files.add(await http.MultipartFile.fromPath('image[]', image.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("Update Expenses ----> "+respStr);
    if (response.statusCode == 200) {
      pr.hide();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(
          'Expenses Updated Successfully!!')));
    } else {
      pr.hide();
      print(response.reasonPhrase);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(
          'Expenses Updated UnSuccessful!!')));
    }
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
                                //initialValue: expensesPrice==null?'No Value':expensesPrice,
                                decoration: new InputDecoration(
                                  //: expensesPrice==null?'No Value':expensesPrice,
                                  hintText: "Expenses Price",
                                  labelText: ExpensesType.toString().toUpperCase()
                                      !=null?ExpensesType.toString().toUpperCase():"Price",
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
                                              expensesImage)
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
                                          uploadmultipleimage(context);
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
}

