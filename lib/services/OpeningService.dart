import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pottery_studio/models/OpeningDto.dart';
import 'package:pottery_studio/services/AuthService.dart';

class OpeningService {
  Dio _dio;
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

  OpeningService(Dio dio) {
    _dio = dio;
  }

  Future<Iterable<OpeningDto>> getAll(bool includePast) async {
    var currentUser = await FirebaseAuth.instance.currentUser();

    var response = await _dio.get("/api/opening?includePast=$includePast");

    if (response.statusCode >= 400) throw Exception("Error");

    List openingsJson = response.data;
    return openingsJson.map(
        (openingJson) => OpeningDto.fromJson(openingJson, currentUser.uid));
  }

  Future<OpeningDto> reserveOpening(String openingId) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId/reserve";
    var response =
        await http.put(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return OpeningDto.fromJson(openingJson, currentUser.uid);
  }

  Future<OpeningDto> removeReservation(String openingId) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId/reserve";
    var response =
        await http.delete(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400) throw Exception("Error");

    var openingJson = json.decode(response.body);
    return OpeningDto.fromJson(openingJson, currentUser.uid);
  }

  Future<OpeningDto> getOpening(String openingId) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    if (response.statusCode >= 400)
      throw Exception("Error ${response.statusCode}");

    var openingJson = json.decode(response.body);
    return OpeningDto.fromJson(openingJson, currentUser.uid);
  }

  Future<OpeningDto> createOpening(OpeningDto openingDto) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
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
    return OpeningDto.fromJson(openingJson, currentUser.uid);
  }

  Future<OpeningDto> updateOpening(OpeningDto openingDto) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
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
    return OpeningDto.fromJson(openingJson, currentUser.uid);
  }

  Future<void> deleteOpening(String openingId) async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/opening/$openingId";
    var response = await http.delete(url, headers: {
      "Authorization": idToken.token,
    });
    if (response.statusCode != 204) throw Exception("Error");
  }
}
