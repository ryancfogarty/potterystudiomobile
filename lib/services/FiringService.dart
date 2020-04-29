import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/DebugUtils.dart';
import 'package:seven_spot_mobile/models/FiringDto.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class FiringService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";
//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<Iterable<FiringDto>> getAll() async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing";
    var response = await http.get(url, headers: {
      "Authorization": idToken.token
    });

    if (response.statusCode >= 400) throw Exception("Error");

    List firingsJson = json.decode(response.body);
    return firingsJson.map((firingJson) => _jsonToDto(firingJson));
  }

  FiringDto _jsonToDto(dynamic firingJson) {
    return FiringDto(firingJson["id"], firingJson["start"], firingJson["durationSeconds"],
        firingJson["cooldownSeconds"], firingJson["type"]);
  }

  Future<FiringDto> getFiring(String firingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing/$firingId";
    var response = await http.get(url, headers: {
      "Authorization": idToken.token
    });

    if (response.statusCode >= 400) throw Exception("Error");

    dynamic firingJson = json.decode(response.body);
    return _jsonToDto(firingJson);
  }
}