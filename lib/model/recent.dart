class Recent {
  final int? id;
  final String? description;
  final int? amount;
  final int? budgetId;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;
  final String? type;

  Recent(
      {this.id,
      this.description,
      this.amount,
      this.budgetId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.type});

  factory Recent.fromJson(Map<String, dynamic> json) {
    return Recent(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      budgetId: json['budget_id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      type: json['type'],
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
    data['type'] = this.type;
    return data;
  }
}
