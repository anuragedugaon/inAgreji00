// lib/models/wallet_balance_model.dart
class WalletBalanceModel {
  final double walletBalance;
  final double earnedCoins;
  final double withdrawableCoins;
  final int conversionRate;
  final int minWithdrawal;
  final double maxWithdrawal;
  final double pendingWithdrawals;
  final double totalWithdrawn;
  final double availableForWithdrawal;

  WalletBalanceModel({
    required this.walletBalance,
    required this.earnedCoins,
    required this.withdrawableCoins,
    required this.conversionRate,
    required this.minWithdrawal,
    required this.maxWithdrawal,
    required this.pendingWithdrawals,
    required this.totalWithdrawn,
    required this.availableForWithdrawal,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return WalletBalanceModel(
      walletBalance: _toDouble(json['wallet_balance']),
      earnedCoins: _toDouble(json['earned_coins']),
      withdrawableCoins: _toDouble(json['withdrawable_coins']),
      conversionRate: _toInt(json['conversion_rate']),
      minWithdrawal: _toInt(json['min_withdrawal']),
      maxWithdrawal: _toDouble(json['max_withdrawal']),
      pendingWithdrawals: _toDouble(json['pending_withdrawals']),
      totalWithdrawn: _toDouble(json['total_withdrawn']),
      availableForWithdrawal: _toDouble(json['available_for_withdrawal']),
    );
  }
}
