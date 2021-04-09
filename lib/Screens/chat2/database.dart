import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseMethods2 {
  /*Future addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }*/

  Future addUserInfo(userData) async {
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    Firestore.instance.collection("users")
        .doc(sharedPreferences.getString("email"))
        .set(userData)
        .catchError((e) {
      print("Firebase SignUP Error--->"+e.toString());
    });
  }

  Future updateUserInfo(userData,email) async {
    Firestore.instance.collection('users')
        .document(email)
        .setData(userData)
        .catchError((e) {
      print("Firebase Update Error--->"+e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  getAllUser()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return Firestore.instance
        .collection("users")
        .where('userName', isNotEqualTo:sharedPreferences.getString("name"))
        .getDocuments();
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  Future addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future addMessage(String chatRoomId, chatMessageData){

    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}