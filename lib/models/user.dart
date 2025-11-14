/// User model for authentication and profile
class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isGuest;
  final DateTime? createdAt;
  final int virtualCoins; // Rewards/coins from challenges
  final List<String> badges; // Earned badges

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isGuest = false,
    this.createdAt,
    this.virtualCoins = 0,
    this.badges = const [],
  });

  // Create guest user
  factory AppUser.guest() {
    return AppUser(
      uid: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: true,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isGuest': isGuest,
      'createdAt': createdAt?.toIso8601String(),
      'virtualCoins': virtualCoins,
      'badges': badges,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      virtualCoins: json['virtualCoins'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isGuest,
    DateTime? createdAt,
    int? virtualCoins,
    List<String>? badges,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      virtualCoins: virtualCoins ?? this.virtualCoins,
      badges: badges ?? this.badges,
    );
  }
}

