import 'dart:convert';

import 'package:seven_spot_mobile/models/UserDto.dart';

import 'AuthService.dart';
import 'package:http/http.dart' as http;

class UserService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";
//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<bool> createUser(String companyName, String companySecret) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user?companySecret=$companySecret&companyName=$companyName";
    var response = await http.post(url,
      headers: { "Authorization": idToken.token });

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<UserDto> getUser() async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user";
    var response = await http.get(url,
        headers: { "Authorization": idToken.token });

    if (response.statusCode != 200) throw Exception("Error");

    var userJson = json.decode(response.body);
    return UserDto(userJson["id"], userJson["companyName"]);
  }
}