/// Stock model representing a Malawi Stock Exchange (MSE) stock
class Stock {
  final String symbol;
  final String name;
  final String sector;
  final double price;
  final double change; // Percentage change
  final int volume;
  final List<OHLCData> ohlc; // Historical OHLC data

  Stock({
    required this.symbol,
    required this.name,
    required this.sector,
    required this.price,
    required this.change,
    required this.volume,
    required this.ohlc,
  });

  // Convert from JSON
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      sector: json['sector'] as String,
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      volume: json['volume'] as int,
      ohlc: (json['ohlc'] as List<dynamic>)
          .map((e) => OHLCData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'sector': sector,
      'price': price,
      'change': change,
      'volume': volume,
      'ohlc': ohlc.map((e) => e.toJson()).toList(),
    };
  }

  // Create a copy with updated price
  Stock copyWith({
    String? symbol,
    String? name,
    String? sector,
    double? price,
    double? change,
    int? volume,
    List<OHLCData>? ohlc,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      sector: sector ?? this.sector,
      price: price ?? this.price,
      change: change ?? this.change,
      volume: volume ?? this.volume,
      ohlc: ohlc ?? this.ohlc,
    );
  }
}

/// OHLC (Open, High, Low, Close) data for charting
class OHLCData {
  final double open;
  final double high;
  final double low;
  final double close;
  final String time;

  OHLCData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.time,
  });

  factory OHLCData.fromJson(Map<String, dynamic> json) {
    return OHLCData(
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'time': time,
    };
  }
}

