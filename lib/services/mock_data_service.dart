import 'dart:math';
import '../models/stock.dart';
import '../utils/constants.dart';

/// Service for managing mock stock data and price updates
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final Random _random = Random();
  List<Stock> _stocks = [];

  /// Initialize stocks from mock data
  List<Stock> initializeStocks() {
    if (_stocks.isEmpty) {
      _stocks = mockStocksJson
          .map((json) => Stock.fromJson(json))
          .toList();
    }
    return _stocks;
  }

  /// Get all stocks
  List<Stock> getStocks() {
    if (_stocks.isEmpty) {
      return initializeStocks();
    }
    return _stocks;
  }

  /// Get stock by symbol
  Stock? getStockBySymbol(String symbol) {
    try {
      return _stocks.firstWhere((s) => s.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  /// Update stock prices with random fluctuations (±5%)
  List<Stock> updateStockPrices() {
    _stocks = _stocks.map((stock) {
      // Generate random change between -5% and +5%
      final changePercent = (_random.nextDouble() * 10) - 5;
      final newPrice = stock.price * (1 + (changePercent / 100));
      
      // Calculate new change percentage
      final basePrice = stock.price / (1 + (stock.change / 100));
      final newChange = ((newPrice - basePrice) / basePrice) * 100;

      // Update volume randomly
      final newVolume = stock.volume + _random.nextInt(500) - 250;
      final safeVolume = newVolume < 0 ? 0 : newVolume;

      // Add new OHLC data point
      final lastClose = stock.ohlc.isNotEmpty 
          ? stock.ohlc.last.close 
          : stock.price;
      final newHigh = newPrice * (1 + _random.nextDouble() * 0.02);
      final newLow = newPrice * (1 - _random.nextDouble() * 0.02);
      
      final newOhlc = List<OHLCData>.from(stock.ohlc);
      if (newOhlc.length >= 7) {
        newOhlc.removeAt(0); // Remove oldest
      }
      newOhlc.add(OHLCData(
        open: lastClose,
        high: newHigh,
        low: newLow,
        close: newPrice,
        time: DateTime.now().toIso8601String().split('T')[0],
      ));

      return stock.copyWith(
        price: newPrice,
        change: newChange,
        volume: safeVolume,
        ohlc: newOhlc,
      );
    }).toList();

    return _stocks;
  }

  /// Search stocks by name or symbol
  List<Stock> searchStocks(String query) {
    if (query.isEmpty) return _stocks;
    
    final lowerQuery = query.toLowerCase();
    return _stocks.where((stock) {
      return stock.symbol.toLowerCase().contains(lowerQuery) ||
          stock.name.toLowerCase().contains(lowerQuery) ||
          stock.sector.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get stocks by sector
  List<Stock> getStocksBySector(String sector) {
    return _stocks.where((stock) => stock.sector == sector).toList();
  }

  /// Get all sectors
  List<String> getSectors() {
    return _stocks.map((s) => s.sector).toSet().toList();
  }
}

