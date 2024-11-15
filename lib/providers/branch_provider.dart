import 'package:flutter/material.dart';
import 'package:queue_parasat/services/dio_service.dart';

import '../model/branch_model.dart';

class BranchProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<BranchModel> _branch = <BranchModel>[];
  List<BranchModel> get branch => _branch;

  Future<void> getBranch() async {
    try {
      // await Future.delayed(const Duration(seconds: 5));
      final result = await DioService().getBranch();
      _branch = result;
    } catch (e) {
      debugPrint('getBranch provider $e');
    } finally {
      debugPrint("branch count ${_branch.length}");
      _isLoading = false;
      notifyListeners();
    }
  }
}
