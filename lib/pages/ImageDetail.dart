import 'package:flutter/material.dart';

class ImageDetail extends StatefulWidget {
  String imgDetail;
  String path;
  ImageDetail({this.imgDetail,this.path});

  @override
  ImageDeatilState createState() => ImageDeatilState();
}

class ImageDeatilState extends State<ImageDetail> {

  var orientation;

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Container(
      child:getList(),
    );
  }
  Widget getList() {
    List<String> list = getListItems();
    var mylist=GridView.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      itemBuilder: (BuildContext context, int index) {
        // print("Print Image --> "+widget.path+list[index].trim());
        var image=widget.path+list[index].trim();
        print("Print Image2 --> "+image);
        return new Card(
          child: new GridTile(
            child: new Image.network(
                image!=null?image:""),
            //just for testing, will fill with image later
          ),
        );
      },
    );
    return mylist;
  }

  List<String> getListItems() {
    return widget.imgDetail.split(',');
  }

}