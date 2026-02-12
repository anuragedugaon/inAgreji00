class ReferralUser {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  ReferralUser({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory ReferralUser.fromJson(Map<String, dynamic> json) {
    return ReferralUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ReferralEntry {
  final int id;
  final int referrerId;
  final int referredId;
  final String subscriptionAmount;
  final String rewardAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReferralUser referred;

  ReferralEntry({
    required this.id,
    required this.referrerId,
    required this.referredId,
    required this.subscriptionAmount,
    required this.rewardAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.referred,
  });

  factory ReferralEntry.fromJson(Map<String, dynamic> json) {
    return ReferralEntry(
      id: json['id'] ?? 0,
      referrerId: json['referrer_id'] ?? 0,
      referredId: json['referred_id'] ?? 0,
      subscriptionAmount: json['subscription_amount'] ?? '0.00',
      rewardAmount: json['reward_amount'] ?? '0.00',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      referred: ReferralUser.fromJson(json['referred'] ?? {}),
    );
  }
}
