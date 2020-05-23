import 'package:seven_spot_mobile/services/StudioService.dart';

class StudioRepository {
  StudioService _service;

  StudioRepository(StudioService service) {
    _service = service;
  }

  Future<bool> createStudio(String userName, String studioName) async {
    return await _service.createStudio(userName, studioName);
  }
}
