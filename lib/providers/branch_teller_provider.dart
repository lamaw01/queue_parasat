import 'package:flutter/material.dart';
import 'package:queue_parasat/services/dio_service.dart';

import '../model/teller_model.dart';
import '../widgets/snackbar_widget.dart';

class BranchTellerProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<TellerModel> _branchTeller = <TellerModel>[];
  List<TellerModel> get branchTeller => _branchTeller;

  Future<void> getBranchTeller({required int branchId}) async {
    try {
      final result = await DioService().getBranchTeller(branchId: branchId);
      _branchTeller = result;
    } catch (e) {
      final String error = "getBranchTeller provider $e";
      debugPrint(error);
      showError(message: error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
