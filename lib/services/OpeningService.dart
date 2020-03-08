import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/models/OpeningDto.dart';

class OpeningService {
  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<Iterable<OpeningDto>> getAll() async {
    var url = "$_baseUrl/api/opening";
    var response = await http.get(url);

    List openingsJson = json.decode(response.body);
    return openingsJson.map((openingJson) => OpeningDto(openingJson["start"]));
  }
}