import 'AuthService.dart';
import 'package:http/http.dart' as http;

class AccountService {
  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";
//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";

  Future<bool> createAccount(String companySecret) async {
    var currentUser = await AuthService().currentUser;
    var idToken = await currentUser.getIdToken(refresh: true);

    var url = "$_baseUrl/api/user?companySecret=$companySecret";
    var response = await http.post(url,
      headers: { "Authorization": idToken.token });

    print(response.statusCode);

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}