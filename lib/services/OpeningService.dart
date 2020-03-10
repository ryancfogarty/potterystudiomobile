import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/models/OpeningDto.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class OpeningService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

  Future<Iterable<OpeningDto>> getAll() async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken();

    var url = "$_baseUrl/api/opening";
    var response = await http.get(url, headers: {
      "Authorization": idToken.token
    });

    List openingsJson = json.decode(response.body);
    return openingsJson.map((openingJson) => OpeningDto(openingJson["start"]));
  }
}