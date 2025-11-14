import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/constants.dart';

/// Resources screen with guides, videos, and quizzes
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: const Text(
          'Resources',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Guides'),
            Tab(text: 'Videos'),
            Tab(text: 'Quiz'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGuidesTab(),
          _buildVideosTab(),
          _buildQuizTab(),
        ],
      ),
    );
  }

  Widget _buildGuidesTab() {
    final guides = [
      {
        'title': 'What is a Stock?',
        'content': '''
A stock represents ownership in a company. When you buy a stock, you become a shareholder and own a small part of that company.

**Key Concepts:**
- **Stock Price**: The current market value of one share
- **Dividends**: Payments made to shareholders from company profits
- **Market Capitalization**: Total value of all company shares
- **Volatility**: How much the stock price fluctuates

**Why Invest?**
- Potential for long-term growth
- Dividend income
- Portfolio diversification
- Beat inflation
        ''',
        'completed': false,
      },
      {
        'title': 'MSE Brokers',
        'content': '''
To invest in the Malawi Stock Exchange (MSE), you need to work with a licensed broker.

**How to Get Started:**
1. Choose a registered MSE broker
2. Open a trading account
3. Deposit funds
4. Place buy/sell orders through your broker
5. Monitor your investments

**Popular Brokers:**
- Stockbrokers Malawi Limited
- FDH Stockbrokers
- NBS Stockbrokers

**Fees:**
- Brokerage fees typically range from 1-2% of transaction value
- Account maintenance fees may apply
- Always check with your broker for current rates
        ''',
        'completed': false,
      },
      {
        'title': 'Understanding P&L',
        'content': '''
**P&L stands for Profit and Loss.**

**How to Calculate:**
- **Profit**: When you sell a stock for more than you paid
- **Loss**: When you sell a stock for less than you paid
- **Formula**: (Selling Price - Purchase Price) × Number of Shares

**Example:**
- Buy 10 shares of ILLO at MWK 1,500 each = MWK 15,000
- Sell 10 shares at MWK 1,600 each = MWK 16,000
- **Profit**: MWK 1,000 (6.67% gain)

**Key Metrics:**
- **Total P&L**: Sum of all gains and losses
- **P&L Percentage**: (Current Value - Cost Basis) / Cost Basis × 100
- **Unrealized P&L**: Gains/losses on stocks you still own
- **Realized P&L**: Gains/losses from stocks you've sold
        ''',
        'completed': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    guide['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (guide['completed'] as bool)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  guide['content'] as String,
                  style: const TextStyle(height: 1.6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    // Placeholder video IDs - replace with actual YouTube video IDs
    final videos = [
      {
        'title': 'Investing Basics for Beginners',
        'videoId': 'dQw4w9WgXcQ', // Placeholder - replace with actual video ID
        'description': 'Learn the fundamentals of stock investing',
      },
      {
        'title': 'Understanding Stock Markets',
        'videoId': 'dQw4w9WgXcQ', // Placeholder - replace with actual video ID
        'description': 'How stock markets work and why they matter',
      },
      {
        'title': 'Portfolio Diversification',
        'videoId': 'dQw4w9WgXcQ', // Placeholder - replace with actual video ID
        'description': 'Why diversification is key to successful investing',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // YouTube player placeholder
              Container(
                height: 200,
                color: AppColors.textSecondary.withOpacity(0.2),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'YouTube Video Player\n(Replace with actual video ID)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video['description'] as String,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test Your Knowledge',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildQuizQuestion(
            question: 'What does P&L stand for?',
            options: [
              'Profit and Loss',
              'Price and Listing',
              'Portfolio and Leverage',
              'Purchase and Liquidation',
            ],
            correctAnswer: 0,
          ),
          const SizedBox(height: 24),
          _buildQuizQuestion(
            question: 'Which sector does ILLO belong to?',
            options: [
              'Banking',
              'Agriculture',
              'Telecommunications',
              'Real Estate',
            ],
            correctAnswer: 1,
          ),
          const SizedBox(height: 24),
          _buildQuizQuestion(
            question: 'What is the main purpose of diversification?',
            options: [
              'To increase returns',
              'To reduce risk',
              'To avoid taxes',
              'To trade more frequently',
            ],
            correctAnswer: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizQuestion({
    required String question,
    required List<String> options,
    required int correctAnswer,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () {
                    final isCorrect = index == correctAnswer;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isCorrect
                              ? 'Correct! Well done!'
                              : 'Incorrect. Try again!',
                        ),
                        backgroundColor:
                            isCorrect ? AppColors.success : AppColors.error,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: Text(option),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

