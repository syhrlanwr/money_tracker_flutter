import 'package:money_track/constant.dart';

class Budget {
  final int totalBudget;

  Budget({required this.totalBudget});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      totalBudget: json['total_budget'],
    );
  }

  Map<String, dynamic> toJson() => {
        'total_budget': totalBudget,
      };
}
