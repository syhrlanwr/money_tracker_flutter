class Income {
  final int? total;
  final List<IncomeDetail>? income;

  Income({this.total, this.income});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      total: json['total'],
      income: json['income'] != null
          ? (json['income'] as List)
              .map((i) => IncomeDetail.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.income != null) {
      data['income'] = this.income!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IncomeDetail {
  final int id;
  final String description;
  final int amount;
  final int budgetId;
  final int userId;
  final String createdAt;
  final String updatedAt;

  IncomeDetail(
      {required this.id,
      required this.description,
      required this.amount,
      required this.budgetId,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});

  factory IncomeDetail.fromJson(Map<String, dynamic> json) {
    return IncomeDetail(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      budgetId: json['budget_id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['budget_id'] = this.budgetId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
