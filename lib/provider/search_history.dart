
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchHistory {

  static const String _searchHistoryPreferences = 'searchHistory';
  List<String> _searchHistory = [];

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyJson = prefs.getString(_searchHistoryPreferences);
    if (historyJson != null && historyJson.isNotEmpty) {
      List<dynamic> historyList = jsonDecode(historyJson);
      _searchHistory = historyList.cast<String>();
    }
    return _searchHistory;
  }

  Future<void> saveSearchHistory(String searchLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _searchHistory.add(searchLocation);
    String historyJson = jsonEncode(_searchHistory);
    await prefs.setString(_searchHistoryPreferences, historyJson);
  }
}