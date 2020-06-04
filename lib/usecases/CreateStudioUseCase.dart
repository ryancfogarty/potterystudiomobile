import 'package:seven_spot_mobile/repositories/StudioRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateStudioUseCase {
  StudioRepository _repo;
  AuthService _authService;

  CreateStudioUseCase(StudioRepository repo, AuthService authService) {
    _repo = repo;
    _authService = authService;
  }

  Future<void> createStudio(
      String userName, String studioName, String imageUrl) async {
    var success = await _repo.createStudio(userName, studioName, imageUrl);

    if (success) {
      _authService.updateState(AppState.REGISTERED);
    } else {
      throw "studio created but user not created";
    }
  }
}
