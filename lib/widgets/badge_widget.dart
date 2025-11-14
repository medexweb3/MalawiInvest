import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget for displaying earned badges
class BadgeWidget extends StatelessWidget {
  final String badgeName;
  final bool isEarned;
  final VoidCallback? onTap;

  const BadgeWidget({
    super.key,
    required this.badgeName,
    this.isEarned = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEarned
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
            width: isEarned ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getBadgeIcon(badgeName),
              size: 40,
              color: isEarned ? AppColors.primary : AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              badgeName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isEarned ? AppColors.textPrimary : AppColors.textSecondary.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            if (isEarned) ...[
              const SizedBox(height: 4),
              const Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.success,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getBadgeIcon(String badgeName) {
    if (badgeName.toLowerCase().contains('first')) {
      return Icons.star;
    } else if (badgeName.toLowerCase().contains('streak')) {
      return Icons.local_fire_department;
    } else if (badgeName.toLowerCase().contains('profit')) {
      return Icons.trending_up;
    } else if (badgeName.toLowerCase().contains('diversify')) {
      return Icons.account_balance;
    } else if (badgeName.toLowerCase().contains('quiz')) {
      return Icons.quiz;
    } else {
      return Icons.emoji_events;
    }
  }
}

/// Badge list widget
class BadgeListWidget extends StatelessWidget {
  final List<String> earnedBadges;
  final List<String> allBadges;

  const BadgeListWidget({
    super.key,
    required this.earnedBadges,
    required this.allBadges,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
    );
  }
}

