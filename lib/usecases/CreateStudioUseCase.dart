import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/repositories/StudioRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateStudioUseCase extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  StudioRepository _repo;
  AuthService _authService;

  CreateStudioUseCase(StudioRepository repo, AuthService authService) {
    _repo = repo;
    _authService = authService;
  }

  Future<void> createStudio(String userName, String studioName) async {
    _loading = true;
    notifyListeners();

    try {
      var success = await _repo.createStudio(userName, studioName);

      if (success) {
        _authService.updateState(AppState.REGISTERED);
      }
    } catch (e) {
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
