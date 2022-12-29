class Outcome {
  final int? total;
  final List<OutcomeDetail>? outcome;

  Outcome({this.total, this.outcome});

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      total: json['total'],
      outcome: json['outcome'] != null
          ? (json['outcome'] as List)
              .map((i) => OutcomeDetail.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.outcome != null) {
      data['outcome'] = this.outcome!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OutcomeDetail {
  final int? id;
  final String? description;
  final int? amount;
  final int? budgetId;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  OutcomeDetail(
      {this.id,
      this.description,
      this.amount,
      this.budgetId,
      this.userId,
      this.createdAt,
      this.updatedAt});

  factory OutcomeDetail.fromJson(Map<String, dynamic> json) {
    return OutcomeDetail(
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
