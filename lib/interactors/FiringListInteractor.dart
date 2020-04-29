import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/models/Firing.dart';
import 'package:seven_spot_mobile/usecases/GetAllFiringsUseCase.dart';

class FiringListInteractor extends ChangeNotifier {
  GetAllFiringsUseCase _getAllFiringsUseCase;
  List<Firing> _firings = new List<Firing>();
  bool _loading = false;

  List<Firing> get firings => _firings;
  bool get loading => _loading;

  FiringListInteractor(GetAllFiringsUseCase getAllFiringsUseCase) {
    _getAllFiringsUseCase = getAllFiringsUseCase;
  }

  Future<void> getAll() async {
    _loading = true;
    notifyListeners();

    try {
      _firings = await _getAllFiringsUseCase.invoke();
    } catch (e) {
      print(e);
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}