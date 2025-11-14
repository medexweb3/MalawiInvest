/// Portfolio holding - represents a stock position
class Holding {
  final String symbol;
  final String name;
  final int shares;
  final double avgPrice; // Average purchase price
  final double currentPrice;
  final double totalValue; // shares * currentPrice
  final double gainLoss; // totalValue - (shares * avgPrice)
  final double gainLossPercent;

  Holding({
    required this.symbol,
    required this.name,
    required this.shares,
    required this.avgPrice,
    required this.currentPrice,
  })  : totalValue = shares * currentPrice,
        gainLoss = (shares * currentPrice) - (shares * avgPrice),
        gainLossPercent = avgPrice > 0
            ? (((currentPrice - avgPrice) / avgPrice) * 100)
            : 0.0;

  // Update with new current price
  Holding updatePrice(double newPrice) {
    return Holding(
      symbol: symbol,
      name: name,
      shares: shares,
      avgPrice: avgPrice,
      currentPrice: newPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'shares': shares,
      'avgPrice': avgPrice,
      'currentPrice': currentPrice,
    };
  }

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      shares: json['shares'] as int,
      avgPrice: (json['avgPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
    );
  }
}

/// Portfolio model - user's investment portfolio
class Portfolio {
  final double cashBalance; // Available cash (MWK)
  final List<Holding> holdings;
  final List<PortfolioSnapshot> history; // Performance history

  Portfolio({
    required this.cashBalance,
    required this.holdings,
    required this.history,
  });

  // Total portfolio value (cash + holdings value)
  double get totalValue {
    final holdingsValue = holdings.fold<double>(
      0.0,
      (sum, holding) => sum + holding.totalValue,
    );
    return cashBalance + holdingsValue;
  }

  // Total gain/loss
  double get totalGainLoss {
    return holdings.fold<double>(
      0.0,
      (sum, holding) => sum + holding.gainLoss,
    );
  }

  // Total gain/loss percentage
  double get totalGainLossPercent {
    final totalCost = holdings.fold<double>(
      0.0,
      (sum, holding) => sum + (holding.shares * holding.avgPrice),
    );
    if (totalCost == 0) return 0.0;
    return (totalGainLoss / totalCost) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'cashBalance': cashBalance,
      'holdings': holdings.map((h) => h.toJson()).toList(),
      'history': history.map((h) => h.toJson()).toList(),
    };
  }

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      cashBalance: (json['cashBalance'] as num).toDouble(),
      holdings: (json['holdings'] as List<dynamic>)
          .map((e) => Holding.fromJson(e as Map<String, dynamic>))
          .toList(),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => PortfolioSnapshot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Portfolio copyWith({
    double? cashBalance,
    List<Holding>? holdings,
    List<PortfolioSnapshot>? history,
  }) {
    return Portfolio(
      cashBalance: cashBalance ?? this.cashBalance,
      holdings: holdings ?? this.holdings,
      history: history ?? this.history,
    );
  }
}

/// Portfolio snapshot for performance tracking
class PortfolioSnapshot {
  final DateTime timestamp;
  final double totalValue;

  PortfolioSnapshot({
    required this.timestamp,
    required this.totalValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'totalValue': totalValue,
    };
  }

  factory PortfolioSnapshot.fromJson(Map<String, dynamic> json) {
    return PortfolioSnapshot(
      timestamp: DateTime.parse(json['timestamp'] as String),
      totalValue: (json['totalValue'] as num).toDouble(),
    );
  }
}

