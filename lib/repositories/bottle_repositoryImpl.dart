import 'dart:convert';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/repositories/bottle_repository.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bottle.dart';

abstract class BottleRepository {
  Future<List<Bottle>> fetchBottles();
  Future<Bottle> fetchBottleDetails(int id);
}

class BottleRepositoryImpl implements BottleRepository {
  final SharedPreferences? sharedPreferences;
  final Connectivity connectivity;
  final Box hiveBox;

  BottleRepositoryImpl({
    required this.sharedPreferences,
    required this.connectivity,
    required this.hiveBox,
  });

  @override
  Future<List<Bottle>> fetchBottles() async {
    try {
      final isOnline = await _checkConnectivity();

      if (isOnline) {
        final bottles = await _fetchFromApi();
        await _cacheBottles(bottles);
        return bottles;
      } else {
        return await _fetchFromCache();
      }
    } catch (e) {
      developer.log('Error fetching bottles: $e', error: e);
      return await _fetchFromMock();
    }
  }

  @override
  Future<Bottle> fetchBottleDetails(int id) async {
    try {
      final bottles = await fetchBottles();
      return bottles.firstWhere((bottle) => bottle.id == id);
    } catch (e) {
      developer.log('Error fetching bottle details: $e', error: e);
      throw Exception('Bottle not found');
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      developer.log('Connectivity check failed: $e', error: e);
      return false;
    }
  }

  Future<List<Bottle>> _fetchFromApi() async {
    developer.log('Fetching from API - using mock data instead');
    return await _fetchFromMock();
  }

  Future<List<Bottle>> _fetchFromMock() async {
    try {
      final jsonString = await rootBundle.loadString('assets/bottle_mock_data.json');
      final jsonData = json.decode(jsonString) as List;
      return jsonData.map((json) => Bottle.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error loading mock data: $e', error: e);
      return [];
    }
  }

  Future<void> _cacheBottles(List<Bottle> bottles) async {
    try {
      final jsonList = bottles.map((b) => b.toJson()).toList();
      final jsonString = json.encode(jsonList);

      await sharedPreferences?.setString('cached_bottles', jsonString);
      await hiveBox.put('cached_bottles', jsonList);
    } catch (e) {
      developer.log('Caching failed: $e', error: e);
    }
  }

  Future<List<Bottle>> _fetchFromCache() async {
    try {
      final cachedData = sharedPreferences?.getString('cached_bottles');
      if (cachedData != null) {
        return _parseBottles(cachedData);
      }

      final hiveData = hiveBox.get('cached_bottles');
      if (hiveData != null) {
        return _parseBottles(json.encode(hiveData));
      }

      return await _fetchFromMock();
    } catch (e) {
      developer.log('Cache read failed: $e', error: e);
      return await _fetchFromMock();
    }
  }

  List<Bottle> _parseBottles(String jsonString) {
    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => Bottle.fromJson(json)).toList();
    } catch (e) {
      developer.log('Parsing bottles failed: $e', error: e);
      throw Exception('Failed to parse cached bottles');
    }
  }
}
