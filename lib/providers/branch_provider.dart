import 'package:flutter/material.dart';
import 'package:queue_parasat/services/dio_service.dart';

import '../model/branch_model.dart';
import '../widgets/snackbar_widget.dart';

class BranchProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<BranchModel> _branch = <BranchModel>[];
  List<BranchModel> get branch => _branch;

  Future<void> getBranch() async {
    try {
      final result = await DioService().getBranch();
      _branch = result;
    } catch (e) {
      debugPrint('getBranch provider $e');
      final String error = "getBranch provider $e";
      debugPrint(error);
      showError(message: error);
    } finally {
      debugPrint("branch count ${_branch.length}");
      _isLoading = false;
      notifyListeners();
    }
  }
}
