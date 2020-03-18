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
    return openingsJson.map((openingJson) {
      List<String> reservedUsers = openingJson["reservedUsers"].cast<String>();

        return OpeningDto(openingJson["start"], openingJson["lengthSeconds"],
          openingJson["size"], reservedUsers, reservedUsers.contains(currentUser.uid));
      }
    );
  }
}