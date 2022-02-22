import 'dart:convert';
import 'dart:io';

import 'package:bawq/core/error/exceptions.dart';
import 'package:bawq/core/util/api_basehelper.dart';
import 'package:bawq/notes/domain/entity/get_all_user.dart';
import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:bawq/notes/domain/usecase/get_notes.dart';
import 'package:bawq/notes/presentation/page/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NotesProvider extends ChangeNotifier {
  String getAllNotesUrl = "http://192.236.155.173:55886/notes/getall";

  String getAllUsersUrl = "http://192.236.155.173:55886/users/getall";
  String addUserUrl = "http://192.236.155.173:55886/notes/insert";

  // Use Cases
  final GetNotes getNotes;

  NotesProvider({required this.getNotes, required this.helper});

  //params
  GetNotesParams getNotesParams = GetNotesParams();

  List<GetNotesResponse> _notes = [];

  List<GetNotesResponse> get notes => _notes;

  Future<void> getAllNotes() async {
    try {
      final response = await http
          .get(Uri.parse(getAllNotesUrl),);
      if (response.statusCode == 200) {
        _notes = List<GetNotesResponse>.from(json
            .decode(response.body)
            .map((x) => GetNotesResponse.fromJson(x)));
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Future<void> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(getAllUsersUrl));
      if (response.statusCode == 200) {
        _users = List<UserModel>.from(
            json.decode(response.body).map((x) => UserModel.fromJson(x)));
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  File? imageUrl;

  bool get isPicked => imageUrl != null;
  final ApiBaseHelper helper;

  bool loading = false;

  Future<void> addUser({
    required String username,
    required String password,
    required String email,
    required BuildContext context,
  }) async {
    loading = true;
    List<int> imageAsBytes = await imageUrl!.readAsBytes();
    final String imageAsBase64 = base64Encode(imageAsBytes);
    try {
      final body = {
        "Username": username,
        "Password": username,
        "Email": username,
        "ImageAsBase64": imageAsBase64,
        "IntrestId": "1"
      };
      final response = await http.post(
          Uri.parse("http://192.236.155.173:55886/users/insert"),
          body: jsonEncode(body),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
    } catch (e) {
      throw UnimplementedError();
    }
    loading = false;
    Fluttertoast.showToast(
        msg: 'Inserted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomePage()));
    notifyListeners();
  }

  Future<void> addNote({
  required String noteContent,
    required BuildContext context,
}) async {
    loading = true;
    try {
      final body = {
        "Text": noteContent,
        "UserId": "3",
        "PlaceDateTime": "2021-11-18T09:39:44",
      };
      final response = await http.post(
          Uri.parse("http://192.236.155.173:55886/notes/insert"),
          body: jsonEncode(body),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
    } catch (e) {
      throw UnimplementedError();
    }
    loading = false;


    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomePage()));
    notifyListeners();
  }

}
