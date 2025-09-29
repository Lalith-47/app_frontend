import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  late Box _cacheBox;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    _cacheBox = await Hive.openBox('cache');
    _initialized = true;
  }

  // Generic cache methods
  Future<void> setCache(String key, dynamic value, {Duration? ttl}) async {
    if (!_initialized) await initialize();
    
    final cacheData = {
      'data': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl?.inMilliseconds,
    };
    
    await _cacheBox.put(key, jsonEncode(cacheData));
  }

  Future<T?> getCache<T>(String key) async {
    if (!_initialized) await initialize();
    
    final cached = _cacheBox.get(key);
    if (cached == null) return null;
    
    try {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final ttl = cacheData['ttl'] as int?;
      
      // Check if cache has expired
      if (ttl != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - timestamp > ttl) {
          await _cacheBox.delete(key);
          return null;
        }
      }
      
      return cacheData['data'] as T?;
    } catch (e) {
      // If parsing fails, remove the corrupted cache
      await _cacheBox.delete(key);
      return null;
    }
  }

  Future<void> removeCache(String key) async {
    if (!_initialized) await initialize();
    await _cacheBox.delete(key);
  }

  Future<void> clearCache() async {
    if (!_initialized) await initialize();
    await _cacheBox.clear();
  }

  // Specific cache methods for different data types
  Future<void> cacheUser(dynamic user) async {
    await setCache('current_user', user);
  }

  Future<Map<String, dynamic>?> getCachedUser() async {
    return await getCache<Map<String, dynamic>>('current_user');
  }

  Future<void> cacheQuizzes(List<dynamic> quizzes) async {
    await setCache('quizzes', quizzes, ttl: const Duration(hours: 1));
  }

  Future<List<dynamic>?> getCachedQuizzes() async {
    return await getCache<List<dynamic>>('quizzes');
  }

  Future<void> cacheQuizResults(List<dynamic> results) async {
    await setCache('quiz_results', results, ttl: const Duration(minutes: 30));
  }

  Future<List<dynamic>?> getCachedQuizResults() async {
    return await getCache<List<dynamic>>('quiz_results');
  }

  Future<void> cacheMessages(String roomId, List<dynamic> messages) async {
    await setCache('messages_$roomId', messages, ttl: const Duration(minutes: 15));
  }

  Future<List<dynamic>?> getCachedMessages(String roomId) async {
    return await getCache<List<dynamic>>('messages_$roomId');
  }

  Future<void> cacheAnalytics(String userId, Map<String, dynamic> analytics) async {
    await setCache('analytics_$userId', analytics, ttl: const Duration(minutes: 30));
  }

  Future<Map<String, dynamic>?> getCachedAnalytics(String userId) async {
    return await getCache<Map<String, dynamic>>('analytics_$userId');
  }

  // Cache statistics
  Future<Map<String, int>> getCacheStats() async {
    if (!_initialized) await initialize();
    
    final keys = _cacheBox.keys.toList();
    final stats = <String, int>{};
    
    for (final key in keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith('messages_')) {
        stats['messages'] = (stats['messages'] ?? 0) + 1;
      } else if (keyStr.startsWith('analytics_')) {
        stats['analytics'] = (stats['analytics'] ?? 0) + 1;
      } else {
        stats['general'] = (stats['general'] ?? 0) + 1;
      }
    }
    
    return stats;
  }

  // Clean expired cache
  Future<void> cleanExpiredCache() async {
    if (!_initialized) await initialize();
    
    final keys = _cacheBox.keys.toList();
    final now = DateTime.now().millisecondsSinceEpoch;
    
    for (final key in keys) {
      try {
        final cached = _cacheBox.get(key);
        if (cached != null) {
          final cacheData = jsonDecode(cached) as Map<String, dynamic>;
          final timestamp = cacheData['timestamp'] as int;
          final ttl = cacheData['ttl'] as int?;
          
          if (ttl != null && now - timestamp > ttl) {
            await _cacheBox.delete(key);
          }
        }
      } catch (e) {
        // Remove corrupted cache entries
        await _cacheBox.delete(key);
      }
    }
  }

  // Cache size management
  Future<void> limitCacheSize(int maxEntries) async {
    if (!_initialized) await initialize();
    
    final keys = _cacheBox.keys.toList();
    if (keys.length <= maxEntries) return;
    
    // Sort by timestamp (oldest first)
    final entries = <MapEntry<String, int>>[];
    for (final key in keys) {
      try {
        final cached = _cacheBox.get(key);
        if (cached != null) {
          final cacheData = jsonDecode(cached) as Map<String, dynamic>;
          final timestamp = cacheData['timestamp'] as int;
          entries.add(MapEntry(key.toString(), timestamp));
        }
      } catch (e) {
        // Remove corrupted entries
        await _cacheBox.delete(key);
      }
    }
    
    entries.sort((a, b) => a.value.compareTo(b.value));
    
    // Remove oldest entries
    final toRemove = entries.take(entries.length - maxEntries);
    for (final entry in toRemove) {
      await _cacheBox.delete(entry.key);
    }
  }
}
