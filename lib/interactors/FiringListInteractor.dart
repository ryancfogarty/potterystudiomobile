import 'package:flutter/widgets.dart';
import 'package:pottery_studio/models/Firing.dart';
import 'package:pottery_studio/usecases/GetAllFiringsUseCase.dart';

class FiringListInteractor extends ChangeNotifier {
  GetAllFiringsUseCase _getAllFiringsUseCase;
  List<Firing> _firings = new List<Firing>();
  bool _loading = false;

  List<Firing> get firings => _firings;

  bool get loading => _loading;

  bool _includePast = false;

  bool get includePast => _includePast;

  FiringListInteractor(GetAllFiringsUseCase getAllFiringsUseCase) {
    _getAllFiringsUseCase = getAllFiringsUseCase;
  }

  void setIncludePast(bool i) {
    _includePast = i;
    notifyListeners();
  }

  Future<void> getAll() async {
    _loading = true;
    notifyListeners();

    try {
      _firings = await _getAllFiringsUseCase.invoke(_includePast);
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
