import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/stock.dart';
import '../utils/constants.dart';

/// Chart widget for displaying stock price history
class ChartWidget extends StatelessWidget {
  final Stock stock;
  final ChartType chartType;

  const ChartWidget({
    super.key,
    required this.stock,
    this.chartType = ChartType.line,
  });

  @override
  Widget build(BuildContext context) {
    if (stock.ohlc.isEmpty) {
      return const Center(
        child: Text('No chart data available'),
      );
    }

    return chartType == ChartType.line
        ? _buildLineChart()
        : _buildCandlestickChart();
  }

  Widget _buildLineChart() {
    final spots = stock.ohlc.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.close);
    }).toList();

    final minY = stock.ohlc.map((e) => e.low).reduce((a, b) => a < b ? a : b) * 0.98;
    final maxY = stock.ohlc.map((e) => e.high).reduce((a, b) => a > b ? a : b) * 1.02;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.textSecondary.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < stock.ohlc.length) {
                  final date = stock.ohlc[value.toInt()].time;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      date.split('-').last, // Show day only
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.2),
          ),
        ),
        minX: 0,
        maxX: (stock.ohlc.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandlestickChart() {
    // Simplified candlestick representation using bar chart
    final bars = stock.ohlc.asMap().entries.map((entry) {
      final ohlc = entry.value;
      final isPositive = ohlc.close >= ohlc.open;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            fromY: ohlc.low,
            toY: ohlc.high,
            color: AppColors.textSecondary.withOpacity(0.3),
            width: 2,
          ),
          BarChartRodData(
            fromY: ohlc.open < ohlc.close ? ohlc.open : ohlc.close,
            toY: ohlc.open > ohlc.close ? ohlc.open : ohlc.close,
            color: isPositive ? AppColors.success : AppColors.error,
            width: 8,
          ),
        ],
      );
    }).toList();

    final minY = stock.ohlc.map((e) => e.low).reduce((a, b) => a < b ? a : b) * 0.98;
    final maxY = stock.ohlc.map((e) => e.high).reduce((a, b) => a > b ? a : b) * 1.02;

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < stock.ohlc.length) {
                  final date = stock.ohlc[value.toInt()].time;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      date.split('-').last,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.2),
          ),
        ),
        minY: minY,
        maxY: maxY,
        barGroups: bars,
      ),
    );
  }
}

enum ChartType { line, candlestick }

