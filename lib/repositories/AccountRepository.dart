import 'package:seven_spot_mobile/services/AccountService.dart';

class AccountRepository {
  AccountService _service;

  AccountRepository() {
    _service = AccountService();
  }

  Future<bool> createAccount(String companySecret) async {
    return await _service.createAccount(companySecret);
  }
}