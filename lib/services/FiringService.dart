import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pottery_studio/models/FiringDto.dart';
import 'package:pottery_studio/services/AuthService.dart';

class FiringService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<Iterable<FiringDto>> getAll(bool includePast) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing?includePast=$includePast";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    print(response.statusCode);

    if (response.statusCode >= 400)
      throw Exception("Error getAll firingService");

    List firingsJson = json.decode(response.body);
    return firingsJson.map((firingJson) => _jsonToDto(firingJson));
  }

  FiringDto _jsonToDto(dynamic firingJson) {
    return FiringDto(
        firingJson["id"],
        firingJson["start"],
        firingJson["durationSeconds"],
        firingJson["cooldownSeconds"],
        firingJson["type"]);
  }

  Future<FiringDto> getFiring(String firingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing/$firingId";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400) throw Exception("Error");

    dynamic firingJson = json.decode(response.body);
    return _jsonToDto(firingJson);
  }

  Future<FiringDto> createFiring(FiringDto firingDto) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing";
    var requestBody = json.encode({
      "id": firingDto.id,
      "start": firingDto.start,
      "durationSeconds": firingDto.durationSeconds,
      "cooldownSeconds": firingDto.cooldownSeconds,
      "type": firingDto.type
    });

    var response = await http.post(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    print(response.statusCode);
    if (response.statusCode >= 400) throw Exception("Error");

    dynamic firingJson = json.decode(response.body);
    return _jsonToDto(firingJson);
  }

  Future<void> deleteFiring(String firingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing/$firingId";
    var response = await http.delete(url, headers: {
      "Authorization": idToken.token,
    });
    if (response.statusCode != 204) throw Exception("Error");
  }

  Future<FiringDto> updateFiring(FiringDto firingDto) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/firing";
    var requestBody = json.encode({
      "id": firingDto.id,
      "start": firingDto.start,
      "durationSeconds": firingDto.durationSeconds,
      "cooldownSeconds": firingDto.cooldownSeconds,
      "type": firingDto.type
    });
    var response = await http.put(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    if (response.statusCode >= 400) throw Exception("Error");

    dynamic firingJson = json.decode(response.body);
    return _jsonToDto(firingJson);
  }
}
