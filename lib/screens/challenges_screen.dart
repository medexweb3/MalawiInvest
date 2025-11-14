import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../providers/auth_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/badge_widget.dart';
import '../utils/constants.dart';

/// Challenges screen with quizzes and mini-games
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final ConfettiController _confettiController = ConfettiController();
  final Random _random = Random();

  @override
  void dispose() {
    _confettiController.dispose();
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
          'Challenges',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User stats
            _buildUserStats(),
            const SizedBox(height: 16),
            // Daily Quiz
            _buildDailyQuiz(),
            const SizedBox(height: 16),
            // Price Prediction Game
            _buildPricePredictionGame(),
            const SizedBox(height: 16),
            // Badges
            _buildBadgesSection(),
            const SizedBox(height: 16),
            // Community Feed
            _buildCommunityFeed(),
          ],
        ),
      ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // Top to bottom
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${user?.virtualCoins ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Coins',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${user?.badges.length ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Badges',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyQuiz() {
    final questions = [
      {
        'question': 'Match ILLO to its sector',
        'options': ['Banking', 'Agriculture', 'Telecom', 'Insurance'],
        'correct': 1,
      },
      {
        'question': 'What does a positive change percentage mean?',
        'options': [
          'Stock price decreased',
          'Stock price increased',
          'No change',
          'Stock was delisted'
        ],
        'correct': 1,
      },
      {
        'question': 'Which is a key principle of investing?',
        'options': [
          'Buy high, sell low',
          'Diversify your portfolio',
          'Invest all money in one stock',
          'Never research companies'
        ],
        'correct': 1,
      },
      {
        'question': 'What is the initial cash balance in this app?',
        'options': ['MWK 50,000', 'MWK 100,000', 'MWK 200,000', 'MWK 500,000'],
        'correct': 1,
      },
      {
        'question': 'What does OHLC stand for?',
        'options': [
          'Open, High, Low, Close',
          'Order, Hold, Limit, Cancel',
          'Option, Hedge, Leverage, Cash',
          'Over, High, Low, Current'
        ],
        'correct': 0,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.quiz, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Daily Quiz',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Answer 5 questions correctly to earn 1000 coins!',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _buildQuizQuestion(
              index: index,
              question: question['question'] as String,
              options: question['options'] as List<String>,
              correctAnswer: question['correct'] as int,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuizQuestion({
    required int index,
    required String question,
    required List<String> options,
    required int correctAnswer,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. $question',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final option = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                onPressed: () async {
                  final isCorrect = optionIndex == correctAnswer;
                  if (isCorrect) {
                    // Award coins if all questions answered correctly
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.updateCoins(
                      (authProvider.user?.virtualCoins ?? 0) + 200,
                    );
                    _confettiController.play();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Correct! +200 coins'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Incorrect. Try again!'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(option),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPricePredictionGame() {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        final stocks = stockProvider.stocks;
        if (stocks.isEmpty) return const SizedBox.shrink();

        final randomStock = stocks[_random.nextInt(stocks.length)];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: AppColors.primary, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Price Prediction Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Predict if ${randomStock.symbol} will go UP or DOWN in the next update.',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _predictPrice(randomStock, true),
                      icon: const Icon(Icons.arrow_upward),
                      label: const Text('UP'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _predictPrice(randomStock, false),
                      icon: const Icon(Icons.arrow_downward),
                      label: const Text('DOWN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _predictPrice(stock, bool predictedUp) async {
    // Simulate price change (in real app, wait for next update)
    final actualChange = _random.nextDouble() > 0.5;
    final isCorrect = predictedUp == actualChange;

    if (isCorrect) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateCoins(
        (authProvider.user?.virtualCoins ?? 0) + 100,
      );
      _confettiController.play();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correct prediction! +100 coins'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong prediction. Try again!'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildBadgesSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final earnedBadges = user?.badges ?? [];
        final allBadges = [
          'First Trade',
          'Quiz Master',
          'Profit Maker',
          'Diversifier',
          'Streak Champion',
        ];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.primary, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Badges',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: allBadges.length,
                itemBuilder: (context, index) {
                  final badge = allBadges[index];
                  return BadgeWidget(
                    badgeName: badge,
                    isEarned: earnedBadges.contains(badge),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommunityFeed() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Community Feed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...mockCommunityPosts.map((post) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    (post['user'] as String)[0],
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                title: Text(
                  post['user'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['message'] as String),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['likes']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          post['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

