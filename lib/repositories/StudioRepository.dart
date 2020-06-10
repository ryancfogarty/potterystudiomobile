import 'package:pottery_studio/services/StudioService.dart';

class StudioRepository {
  StudioService _service;

  StudioRepository(StudioService service) {
    _service = service;
  }

  Future<bool> createStudio(
      String userName, String studioName, String imageUrl) async {
    return await _service.createStudio(userName, studioName, imageUrl);
  }

  Future<void> updateStudioBanner(String banner) async {
    return await _service.updateStudioBanner(banner);
  }
}
