import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/stock_provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/portfolio.dart';
import '../widgets/chart_widget.dart';
import '../widgets/buy_sell_dialog.dart';
import '../utils/constants.dart';

/// Stock detail screen with chart and buy/sell options
class StockDetailScreen extends StatefulWidget {
  final String symbol;

  const StockDetailScreen({
    super.key,
    required this.symbol,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  ChartType _chartType = ChartType.line;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          widget.symbol,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _chartType == ChartType.line
                  ? Icons.show_chart
                  : Icons.candlestick_chart,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _chartType = _chartType == ChartType.line
                    ? ChartType.candlestick
                    : ChartType.line;
              });
            },
          ),
        ],
      ),
      body: Consumer<StockProvider>(
        builder: (context, stockProvider, child) {
          final stock = stockProvider.getStockBySymbol(widget.symbol);
          
          if (stock == null) {
            return const Center(
              child: Text('Stock not found'),
            );
          }

          final isPositive = stock.change >= 0;
          final changeColor = isPositive ? AppColors.success : AppColors.error;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stock.sector,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Price',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'MWK ${stock.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text(
                                    '${isPositive ? '+' : ''}${stock.change.toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Vol: ${stock.volume}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Chart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ChartWidget(
                      stock: stock,
                      chartType: _chartType,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Buy/Sell buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showBuyDialog(context, stock),
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Buy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showSellDialog(context, stock),
                          icon: const Icon(Icons.remove_circle_outline),
                          label: const Text('Sell'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBuyDialog(BuildContext context, stock) async {
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);
    final portfolio = portfolioProvider.portfolio;

    final shares = await showDialog<int>(
      context: context,
      builder: (context) => BuySellDialog(
        stock: stock,
        isBuy: true,
        availableCash: portfolio?.cashBalance,
      ),
    );

    if (shares != null && shares > 0) {
      final success = await portfolioProvider.buyStock(stock, shares);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Successfully bought $shares shares of ${stock.symbol}'
                  : portfolioProvider.error ?? 'Failed to buy stock',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  void _showSellDialog(BuildContext context, stock) async {
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);
    final portfolio = portfolioProvider.portfolio;

    Holding? holding;
    try {
      holding = portfolio?.holdings.firstWhere(
        (h) => h.symbol == stock.symbol,
      );
    } catch (e) {
      holding = null;
    }

    if (holding == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You don\'t own this stock'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // At this point, holding is guaranteed to be non-null
    final nonNullHolding = holding!;
    
    final shares = await showDialog<int>(
      context: context,
      builder: (context) => BuySellDialog(
        stock: stock,
        isBuy: false,
        availableShares: nonNullHolding.shares,
      ),
    );

    if (shares != null && shares > 0) {
      final success = await portfolioProvider.sellStock(stock.symbol, shares);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Successfully sold $shares shares of ${stock.symbol}'
                  : portfolioProvider.error ?? 'Failed to sell stock',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }
}

