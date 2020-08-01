import 'package:pottery_studio/repositories/StudioRepository.dart';
import 'package:pottery_studio/services/AuthService.dart';

import 'GetUserUseCase.dart';

class CreateStudioUseCase {
  StudioRepository _repo;
  AuthService _authService;
  GetUserUseCase _getUserUseCase;

  CreateStudioUseCase(StudioRepository repo, AuthService authService, GetUserUseCase getUserUseCase) {
    _repo = repo;
    _authService = authService;
    _getUserUseCase = getUserUseCase;
  }

  Future<void> createStudio(
      String userName, String studioName, String imageUrl) async {
    var success = await _repo.createStudio(userName, studioName, imageUrl);

    if (success) {
      await _getUserUseCase.getUser(clearCache: true);
      _authService.updateState(AppState.REGISTERED);
    } else {
      throw "studio created but user not created";
    }
  }
}
