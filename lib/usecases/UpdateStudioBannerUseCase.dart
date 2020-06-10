import 'package:flutter/material.dart';
import 'package:pottery_studio/repositories/StudioRepository.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';

class UpdateStudioBannerUseCase extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  StudioRepository _repo;
  GetUserUseCase _getUserUseCase;

  UpdateStudioBannerUseCase(StudioRepository repo,
      GetUserUseCase getUserUseCase) {
    _repo = repo;
    _getUserUseCase = getUserUseCase;
  }

  Future<void> invoke(String banner) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.updateStudioBanner(banner);
      await _getUserUseCase.getUser();
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}