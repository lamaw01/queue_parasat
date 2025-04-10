import 'package:flutter/material.dart';

import '../model/log_model.dart';
import '../services/dio_service.dart';
import '../widgets/snackbar_widget.dart';

class CounterProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  List<LogModel> _log = <LogModel>[];
  List<LogModel> get log => _log;

  List<LogModel> _previouslog = <LogModel>[];
  List<LogModel> get previouslog => _previouslog;

  Future<void> getCounter({required int branchId}) async {
    try {
      final result = await DioService().getCounter(branchId: branchId);
      _counter = result;
    } catch (e) {
      final String error = "getCounter provider $e";
      debugPrint(error);
      showError(message: error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateCounter({required int branchId, required String name}) async {
    try {
      final result = await DioService().updateCounter(branchId: branchId, name: name);
      _counter = result;
    } catch (e) {
      final String error = "updateCounter provider $e";
      debugPrint(error);
      showError(message: error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetCounter({required int branchId, required String name}) async {
    try {
      final result = await DioService().resetCounter(branchId: branchId, name: name);
      _counter = result;
    } catch (e) {
      final String error = "resetCounter provider $e";
      debugPrint(error);
      showError(message: error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getLog({required int branchId}) async {
    try {
      final result = await DioService().getLog(branchId: branchId);
      _log = result;
      if (result.length > 1) {
        _previouslog = result.sublist(1, result.length);
      } else {
        _previouslog.clear();
      }
    } catch (e) {
      debugPrint('getLog provider $e');
      final String error = "getLog provider $e";
      debugPrint(error);
      showError(message: error);
    } finally {
      notifyListeners();
    }
  }
}
