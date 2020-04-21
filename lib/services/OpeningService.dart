import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/DebugUtils.dart';
import 'package:seven_spot_mobile/models/OpeningDto.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class OpeningService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";
//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<Iterable<OpeningDto>> getAll() async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening";
    var response = await http.get(url, headers: {
      "Authorization": idToken.token
    });

    printLongString(idToken.token);
    if (response.statusCode >= 400) throw Exception("Error");

    List openingsJson = json.decode(response.body);
    return openingsJson.map((openingJson) => _jsonToDto(openingJson, currentUser.uid));
  }

  OpeningDto _jsonToDto(dynamic openingJson, String currentUserId) {
    List<String> reservedUserIds = openingJson["reservedUserIds"].cast<String>();

    return OpeningDto(openingJson["id"], openingJson["start"], openingJson["lengthSeconds"],
        openingJson["size"], reservedUserIds, reservedUserIds.contains(currentUserId));
  }

  Future<OpeningDto> reserveOpening(String openingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId/reserve";
    var response = await http.put(url, headers: {
      "Authorization": idToken.token
    });

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return _jsonToDto(openingJson, currentUser.uid);
  }

  Future<OpeningDto> removeReservation(String openingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId/reserve";
    var response = await http.delete(url, headers: {
      "Authorization": idToken.token
    });

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return _jsonToDto(openingJson, currentUser.uid);
  }
}