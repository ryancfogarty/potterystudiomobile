import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/DebugUtils.dart';
import 'package:seven_spot_mobile/models/OpeningDto.dart';
import 'package:seven_spot_mobile/models/UserDto.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class OpeningService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<Iterable<OpeningDto>> getAll(bool includePast) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening?includePast=$includePast";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    printLongString(idToken.token);
    if (response.statusCode >= 400) throw Exception("Error");

    List openingsJson = json.decode(response.body);
    return openingsJson
        .map((openingJson) => _jsonToDto(openingJson, currentUser.uid));
  }

  OpeningDto _jsonToDto(dynamic openingJson, String currentUserId) {
    List<String> reservedUserIds =
        openingJson["reservedUserIds"].cast<String>();
    List<UserDto> reservedUserDtos = [
      for (var userJson in (openingJson["reservedUsers"] ?? []))
        UserDto(
            userJson["id"],
            userJson["studioName"],
            userJson["name"],
            userJson["isAdmin"] ?? false,
            userJson["studioCode"],
            userJson["studioAdminCode"])
    ];

    return OpeningDto(
        openingJson["id"],
        openingJson["start"],
        openingJson["lengthSeconds"],
        openingJson["size"],
        reservedUserIds,
        reservedUserIds.contains(currentUserId),
        reservedUserDtos);
  }

  Future<OpeningDto> reserveOpening(String openingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId/reserve";
    var response =
        await http.put(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return _jsonToDto(openingJson, currentUser.uid);
  }

  Future<OpeningDto> removeReservation(String openingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId/reserve";
    var response =
        await http.delete(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return _jsonToDto(openingJson, currentUser.uid);
  }

  Future<OpeningDto> getOpening(String openingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400) throw Exception("Error ${response.statusCode}");

    var openingJson = json.decode(response.body);
    return _jsonToDto(openingJson, currentUser.uid);
  }

  Future<OpeningDto> createOpening(OpeningDto openingDto) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var occurrences = {
      "numberOfOccurrences": openingDto.numberOfOccurrences,
      "type": openingDto.recurrenceType
    };

    var url = "$_baseUrl/api/opening";
    var requestBody = json.encode({
      "start": openingDto.start,
      "lengthSeconds": openingDto.lengthSeconds,
      "size": openingDto.size,
      "recurrence": openingDto.recurring ? occurrences : null
    });
    var response = await http.post(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });

    print(response.statusCode);

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body)[0];
    return _jsonToDto(openingJson, currentUser.uid);
  }

  Future<OpeningDto> updateOpening(OpeningDto openingDto) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening";
    var requestBody = json.encode({
      "id": openingDto.id,
      "start": openingDto.start,
      "lengthSeconds": openingDto.lengthSeconds,
      "size": openingDto.size
    });
    var response = await http.put(url, body: requestBody, headers: {
      "Authorization": idToken.token,
      "Content-Type": "application/json"
    });
    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return _jsonToDto(openingJson, currentUser.uid);
  }

  Future<void> deleteOpening(String openingId) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId";
    var response = await http.delete(url, headers: {
      "Authorization": idToken.token,
    });
    if (response.statusCode != 204) throw Exception("Error");
  }
}
