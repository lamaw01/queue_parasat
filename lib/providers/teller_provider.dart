import 'package:flutter/material.dart';
import 'package:queue_parasat/services/dio_service.dart';

import '../model/teller_model.dart';

class TellerProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<TellerModel> _teller = <TellerModel>[];
  List<TellerModel> get teller => _teller;

  Future<void> getTeller() async {
    try {
      final result = await DioService().getTeller();
      _teller = result;
    } catch (e) {
      debugPrint('getBranch provider $e');
    } finally {
      debugPrint("teller count ${_teller.length}");
      _isLoading = false;
      notifyListeners();
    }
  }
}
