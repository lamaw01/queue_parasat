import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:queue_parasat/model/teller_model.dart';

import '../model/branch_model.dart';

class DioService {
  static const String _serverUrl = 'https://konek.parasat.tv:53000/';

  final _dio = Dio(
    BaseOptions(
      baseUrl: '$_serverUrl/branch_queue_api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ),
  );

  Future<List<BranchModel>> getBranch() async {
    final response = await _dio.get('/branch.php');
    debugPrint("getBranch dio ${response.data}");
    return branchModelFromJson(json.encode(response.data));
  }

  Future<List<TellerModel>> getTeller() async {
    final response = await _dio.get('/teller.php');
    debugPrint("getTeller ${response.data}");
    return tellerModelFromJson(json.encode(response.data));
  }

  Future<List<TellerModel>> getBranchTeller({required int branchId}) async {
    final response = await _dio.post(
      '/branch_teller.php',
      data: {'branch_id': branchId},
    );
    debugPrint("getTeller ${response.data}");
    return tellerModelFromJson(json.encode(response.data));
  }

  Future<int> getCounter({required int branchId}) async {
    final response = await _dio.post(
      '/get_counter.php',
      data: {'branch_id': branchId},
    );
    debugPrint("getCounter ${response.data}");
    return response.data;
  }

  Future<int> updateCounter({required int branchId, required String name}) async {
    final response = await _dio.post(
      '/update_counter.php',
      data: {'branch_id': branchId, 'name': name},
    );
    debugPrint("updateCounter ${response.data}");
    return response.data;
  }

  Future<int> resetCounter({required int branchId, required String name}) async {
    final response = await _dio.post(
      '/reset_counter.php',
      data: {'branch_id': branchId, 'name': name},
    );
    debugPrint("resetCounter ${response.data}");
    return response.data;
  }

  Future<void> updateTeller({
    required int id,
    required int counter,
    required String name,
    required String type,
    required String window,
    required int active,
  }) async {
    final response = await _dio.post(
      '/update_teller.php',
      data: {
        'id': id,
        'counter': counter,
        'name': name,
        'type': type,
        'window': window,
        'active': active,
      },
    );
    debugPrint("updateTeller ${response.data}");
  }

  Future<void> insertTeller({
    required String name,
    required String type,
    required int branchId,
    required String window,
  }) async {
    final response = await _dio.post(
      '/insert_teller.php',
      data: {
        'name': name,
        'type': type,
        'branch_id': branchId,
        'window': window,
      },
    );
    debugPrint("insertTeller ${response.data}");
  }
}
