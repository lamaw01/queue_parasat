import 'package:flutter/material.dart';

import '../services/dio_service.dart';

class CounterProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  Future<void> getCounter({required int branchId}) async {
    try {
      final result = await DioService().getCounter(branchId: branchId);
      _counter = result;
    } catch (e) {
      debugPrint('getCounter provider $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateCounter({required int branchId, required String name}) async {
    try {
      final result = await DioService().updateCounter(branchId: branchId, name: name);
      _counter = result;
    } catch (e) {
      debugPrint('updateCounter provider $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetCounter({required int branchId, required String name}) async {
    try {
      final result = await DioService().resetCounter(branchId: branchId, name: name);
      _counter = result;
    } catch (e) {
      debugPrint('resetCounter provider $e');
    } finally {
      notifyListeners();
    }
  }
}
