import 'package:flutter/cupertino.dart';
import 'package:my_domain/domain.dart';

class MyViewModel extends ValueNotifier<User?> {
  final GetMyUseCase _getMyUseCase;

  MyViewModel(this._getMyUseCase) : super(null);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final User result = await _getMyUseCase.execute();
      _isLoading = false;
      value = result;
    } catch (ignore) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
