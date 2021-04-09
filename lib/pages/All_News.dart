import 'dart:convert';
import 'package:AYT_Attendence/API/api.dart';
import 'package:AYT_Attendence/model/NewsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'NewsDetail.dart';

class All_News extends StatefulWidget {
  @override
  newsFeedsState createState() => newsFeedsState();
}

class newsFeedsState extends State<All_News> {
  Future<Newsmodel> newsdetail() async {
    var endpointUrl = All_API().baseurl + All_API().api_news;
    Map<String, String> queryParameter = {
      'status': '1',
    };
    String queryString = Uri(queryParameters: queryParameter).query;
    var requestUrl = endpointUrl + '?' + queryString;
    print(requestUrl);
    try {
      var response = await http.get(requestUrl, headers: {
        All_API().key: All_API().keyvalue,
      });
      print("News : " + response.body);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print("News : " + jsonString);
        var jsonMap = json.decode(jsonString);
        return Newsmodel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return Exception;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Container(
          child: Text(
            'All News',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[1000],
      ),
      body: FutureBuilder<Newsmodel>(
        future: newsdetail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var path = All_API().baseurl_img + snapshot.data.path;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.data.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var article = snapshot.data.data[index];
                  return Card(
                    elevation: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NeswDetail(
                                  image: article.image,
                                  path: path,
                                  title: article.title,
                                  description: article.description,
                                  author: article.author,
                                )));
                      },
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              path + article.image,
                                            ),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(75.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 7.0,
                                              color: Colors.black)
                                        ]),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          article.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          article.description,
                                          maxLines: 4,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(6.0),
                                        child:Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            article.author,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),),


                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }else {
            return Center(

              child: snapshot.hasData == false
                  ? CircularProgressIndicator()
                  : TextShowing(),
            );
          }
          // return Center(child:CircularProgressIndicator() ,);

        },
      ),
    );
  }
}

TextShowing<Widget>() {
  Text("No Data");
}
