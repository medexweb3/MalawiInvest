import 'package:flutter/foundation.dart';
import '../models/portfolio.dart';
import '../models/stock.dart';
import '../services/firebase_service.dart';
import '../utils/constants.dart';

/// Portfolio provider for managing user portfolio
class PortfolioProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  Portfolio? _portfolio;
  bool _isLoading = false;
  String? _error;
  String? _userId;

  Portfolio? get portfolio => _portfolio;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize portfolio for a user
  Future<void> initializePortfolio(String userId) async {
    _userId = userId;
    _isLoading = true;
    notifyListeners();

    try {
      _portfolio = await _firebaseService.loadPortfolio(userId);
      if (_portfolio == null) {
        _portfolio = Portfolio(
          cashBalance: initialCashBalance,
          holdings: [],
          history: [],
        );
        await _firebaseService.savePortfolio(userId, _portfolio!);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Buy stock
  Future<bool> buyStock(Stock stock, int shares) async {
    if (_portfolio == null || _userId == null) return false;

    final totalCost = stock.price * shares;
    if (totalCost > _portfolio!.cashBalance) {
      _error = 'Insufficient funds';
      notifyListeners();
      return false;
    }

    if (shares <= 0) {
      _error = 'Invalid number of shares';
      notifyListeners();
      return false;
    }

    try {
      // Check if user already owns this stock
      final existingIndex = _portfolio!.holdings.indexWhere(
        (h) => h.symbol == stock.symbol,
      );

      List<Holding> newHoldings = List.from(_portfolio!.holdings);

      if (existingIndex >= 0) {
        // Update existing holding with weighted average
        final existing = newHoldings[existingIndex];
        final totalShares = existing.shares + shares;
        final totalCost = (existing.avgPrice * existing.shares) + (stock.price * shares);
        final newAvgPrice = totalCost / totalShares;

        newHoldings[existingIndex] = Holding(
          symbol: stock.symbol,
          name: stock.name,
          shares: totalShares,
          avgPrice: newAvgPrice,
          currentPrice: stock.price,
        );
      } else {
        // Add new holding
        newHoldings.add(Holding(
          symbol: stock.symbol,
          name: stock.name,
          shares: shares,
          avgPrice: stock.price,
          currentPrice: stock.price,
        ));
      }

      // Update portfolio
      _portfolio = _portfolio!.copyWith(
        cashBalance: _portfolio!.cashBalance - totalCost,
        holdings: newHoldings,
      );

      // Add to history
      _addHistorySnapshot();

      // Save to Firebase
      await _firebaseService.savePortfolio(_userId!, _portfolio!);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Sell stock
  Future<bool> sellStock(String symbol, int shares) async {
    if (_portfolio == null || _userId == null) return false;

    final holdingIndex = _portfolio!.holdings.indexWhere(
      (h) => h.symbol == symbol,
    );

    if (holdingIndex < 0) {
      _error = 'Stock not found in portfolio';
      notifyListeners();
      return false;
    }

    final holding = _portfolio!.holdings[holdingIndex];
    if (shares > holding.shares) {
      _error = 'Insufficient shares';
      notifyListeners();
      return false;
    }

    if (shares <= 0) {
      _error = 'Invalid number of shares';
      notifyListeners();
      return false;
    }

    try {
      final saleValue = holding.currentPrice * shares;
      List<Holding> newHoldings = List.from(_portfolio!.holdings);

      if (shares == holding.shares) {
        // Remove holding completely
        newHoldings.removeAt(holdingIndex);
      } else {
        // Update holding
        newHoldings[holdingIndex] = Holding(
          symbol: holding.symbol,
          name: holding.name,
          shares: holding.shares - shares,
          avgPrice: holding.avgPrice,
          currentPrice: holding.currentPrice,
        );
      }

      // Update portfolio
      _portfolio = _portfolio!.copyWith(
        cashBalance: _portfolio!.cashBalance + saleValue,
        holdings: newHoldings,
      );

      // Add to history
      _addHistorySnapshot();

      // Save to Firebase
      await _firebaseService.savePortfolio(_userId!, _portfolio!);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update holding prices (called when stock prices update)
  void updateHoldingPrices(List<Stock> stocks) {
    if (_portfolio == null) return;

    final updatedHoldings = _portfolio!.holdings.map((holding) {
      final stock = stocks.firstWhere(
        (s) => s.symbol == holding.symbol,
        orElse: () => Stock(
          symbol: holding.symbol,
          name: holding.name,
          sector: '',
          price: holding.currentPrice,
          change: 0,
          volume: 0,
          ohlc: [],
        ),
      );
      return holding.updatePrice(stock.price);
    }).toList();

    _portfolio = _portfolio!.copyWith(holdings: updatedHoldings);
    notifyListeners();
  }

  /// Add history snapshot
  void _addHistorySnapshot() {
    if (_portfolio == null) return;

    final snapshot = PortfolioSnapshot(
      timestamp: DateTime.now(),
      totalValue: _portfolio!.totalValue,
    );

    final newHistory = List<PortfolioSnapshot>.from(_portfolio!.history)
      ..add(snapshot);

    // Keep only last 30 days of history
    if (newHistory.length > 30) {
      newHistory.removeAt(0);
    }

    _portfolio = _portfolio!.copyWith(history: newHistory);
  }

  /// Refresh portfolio
  Future<void> refreshPortfolio() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _portfolio = await _firebaseService.loadPortfolio(_userId!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

