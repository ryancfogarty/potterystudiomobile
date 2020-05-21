import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/models/UserDto.dart';

import 'AuthService.dart';

class UserService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<bool> createUser(String studioCode, String displayName) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var requestBody =
        json.encode({"name": displayName, "studioCode": studioCode});

    var url = "$_baseUrl/api/user";
    var response = await http.post(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<UserDto> getUser() async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 200) throw Exception("Error");

    var userJson = json.decode(response.body);
    return UserDto(userJson["id"], userJson["studioName"], userJson["name"],
        userJson["isAdmin"] ?? false);
  }

  Future<void> deleteUser() async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user";
    var response =
        await http.delete(url, headers: {"Authorization": idToken.token});

    if (response.statusCode != 204) throw Exception("Error");
  }
}
