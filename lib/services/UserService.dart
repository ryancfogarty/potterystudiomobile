import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pottery_studio/models/UserDto.dart';

class UserService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<void> createUser(
      String studioCode, String displayName, String imageUrl) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var requestBody = json.encode({
      "name": displayName,
      "studioCode": studioCode,
      "profileImageUrl": imageUrl
    });

    var url = "$_baseUrl/api/user";
    var response = await http.post(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "error";
    }
  }

  Future<UserDto> getUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 200) throw Exception("Error");

    var userJson = json.decode(response.body);
    return UserDto.fromJson(userJson);
  }

  Future<void> deleteUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user";
    var response =
        await http.delete(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 204) throw Exception("Error");
  }

  Future<void> registerAsAdmin(String adminCode) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var requestBody = json.encode({"adminCode": adminCode});
    var url = "$_baseUrl/api/user/admin";

    var response = await http.put(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    if (response.statusCode != 200) throw Exception("Error");
  }

  Future<UserDto> updateUser(String name, String profileImageUrl) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var requestBody =
        json.encode({"name": name, "profileImageUrl": profileImageUrl});
    var url = "$_baseUrl/api/user";

    var response = await http.put(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    if (response.statusCode != 200) throw Exception("Error");

    var userJson = json.decode(response.body);
    return UserDto.fromJson(userJson);
  }

  Future<Iterable<UserDto>> presentUsers() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user/present";

    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 200) throw Exception("Error");

    List usersJson = json.decode(response.body);
    return usersJson.map((userJson) => UserDto.fromJson(userJson));
  }

  Future<void> checkIn() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user/present";

    var response =
        await http.put(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 200) throw Exception("Error");
  }

  Future<void> checkOut() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user/absent";

    var response =
        await http.put(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 200) throw Exception("Error");
  }
}
