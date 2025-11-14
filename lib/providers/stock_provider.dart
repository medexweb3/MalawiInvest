import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/stock.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';

/// Stock provider for managing stock data and price updates
class StockProvider with ChangeNotifier {
  final MockDataService _mockDataService = MockDataService();
  Timer? _priceUpdateTimer;
  
  List<Stock> _stocks = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Stock> get stocks => _searchQuery.isEmpty 
      ? _stocks 
      : _mockDataService.searchStocks(_searchQuery);
  bool get isLoading => _isLoading;
  String? get error => _error;

  StockProvider() {
    _initializeStocks();
    _startPriceUpdates();
  }

  /// Initialize stocks from mock data
  void _initializeStocks() {
    _isLoading = true;
    notifyListeners();

    try {
      _stocks = _mockDataService.initializeStocks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Start automatic price updates every 30 seconds
  void _startPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(
      Duration(seconds: priceUpdateInterval),
      (_) => _updatePrices(),
    );
  }

  /// Update stock prices
  void _updatePrices() {
    try {
      _stocks = _mockDataService.updateStockPrices();
      notifyListeners();
    } catch (e) {
      // Silently handle errors in background updates
    }
  }

  /// Get stock by symbol
  Stock? getStockBySymbol(String symbol) {
    return _mockDataService.getStockBySymbol(symbol);
  }

  /// Refresh stocks manually
  Future<void> refreshStocks() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      _updatePrices();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search stocks
  void searchStocks(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Get stocks by sector
  List<Stock> getStocksBySector(String sector) {
    return _mockDataService.getStocksBySector(sector);
  }

  /// Get all sectors
  List<String> getSectors() {
    return _mockDataService.getSectors();
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }
}

