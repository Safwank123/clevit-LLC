import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bottle.dart';

abstract class BottleRepository {
  Future<List<Bottle>> fetchBottles();
  Future<Bottle> fetchBottleDetails(int id);
}

class BottleRepositoryImpl implements BottleRepository {
  final SharedPreferences sharedPreferences;
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
      return await _getDefaultBottles(); // Fallback to default data
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
    // In a real app, this would make an API call
    try {
      return await _fetchFromMock();
    } catch (e) {
      developer.log('API fetch failed, using mock data: $e', error: e);
      return await _getDefaultBottles();
    }
  }

  Future<List<Bottle>> _fetchFromMock() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock_bottles.json');
      if (jsonString.isEmpty) {
        throw Exception('Mock data file is empty');
      }
      final jsonData = json.decode(jsonString) as List;
      return jsonData.map((json) => Bottle.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error loading mock data: $e', error: e);
      return await _getDefaultBottles();
    }
  }

  Future<void> _cacheBottles(List<Bottle> bottles) async {
    try {
      final jsonList = bottles.map((b) => b.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await sharedPreferences.setString('cached_bottles', jsonString);
      await hiveBox.put('cached_bottles', jsonList);
    } catch (e) {
      developer.log('Caching failed: $e', error: e);
    }
  }

  Future<List<Bottle>> _fetchFromCache() async {
    try {
      // Try SharedPreferences first
      final cachedData = sharedPreferences.getString('cached_bottles');
      if (cachedData != null) {
        return _parseBottles(cachedData);
      }
      
      // Fallback to Hive
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
      return [];
    }
  }

  Future<List<Bottle>> _getDefaultBottles() async {
    // Hardcoded fallback data
    return [
      Bottle(
        id: 2504,
        name: 'Talisker 18 Year old',
        labelNumber: 'Bottle 135/184',
        details: BottleDetails(
          distillery: 'Talisker',
          region: 'Isle of Skye',
          country: 'Scotland',
          type: 'Single Malt',
          ageStatement: '18 years',
          filled: '2004',
          bottled: '2022',
          caskNumber: '1234',
          abv: '45.8%',
          size: '700ml',
          finish: 'Long, warming',
        ),
        tastingNotes: TastingNotes(
          videoUrl: 'assets/video/preview.png',
          expert: 'Charles MacLean MBE',
          nose: ['Rich and peaty', 'Subtle caramel', 'Sea brine'],
          palate: ['Smoky oak', 'Sea salt', 'Dried fruit'],
          finish: ['Warm', 'Lingering', 'Smoky'],
        ),
        history: [
          HistoryItem(
            label: 'Label',
            title: 'Genesis Collection',
            description: ['Crafted by master distillers', 'Matured for over 18 years'],
            attachments: [
              'assets/images/product-image.png',
              'assets/images/product-image.png',
              'assets/images/product-image.png'
            ],
          ),
        ],
      )
    ];
  }
}

extension BottleSerialization on Bottle {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bottle_name': name,
      'label_number': labelNumber,
      'details': {
        'Distillery': details.distillery,
        'Region': details.region,
        'Country': details.country,
        'Type': details.type,
        'Age statement': details.ageStatement,
        'Filled': details.filled,
        'Bottled': details.bottled,
        'Cask number': details.caskNumber,
        'ABV': details.abv,
        'Size': details.size,
        'Finish': details.finish,
      },
      'tasting_notes': {
        'video_url': tastingNotes.videoUrl,
        'expert': tastingNotes.expert,
        'Nose': tastingNotes.nose,
        'Palate': tastingNotes.palate,
        'Finish': tastingNotes.finish,
      },
      'history': history.map((h) => {
            'label': h.label,
            'title': h.title,
            'description': h.description,
            'attachments': h.attachments,
          }).toList(),
    };
  }
}