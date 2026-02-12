import 'dart:convert';

class PlanModel {
  bool? success;
  String? message;
  List<PlanData>? data;

  PlanModel({
    this.success,
    this.message,
    this.data,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        success: json['success'],
        message: json['message'],
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => PlanData.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class PlanData {
  int? id;
  String? name;
  String? description;
  num? price;
  String? interval;
  int? intervalCount;
  int? durationDays;
  List<String>? features;
  String? gatewayPlanId;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  /// 🔥 New Key from API
  int? isTrialPlan;

  PlanData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.interval,
    this.intervalCount,
    this.durationDays,
    this.features,
    this.gatewayPlanId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.isTrialPlan,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
  

    return PlanData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      interval: json['interval'],
      intervalCount: json['interval_count'],
      durationDays: json['duration_days'],
   // ⭐ Safe casting of features list
    features: json['features'] != null
        ? List<String>.from(json['features'].map((e) => e.toString()))
        : [],
      gatewayPlanId: json['gateway_plan_id'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      /// Assign `is_trial_plan`
      isTrialPlan: int.tryParse(json['is_trial_plan']?.toString() ?? "0"),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'interval': interval,
        'interval_count': intervalCount,
        'duration_days': durationDays,
        'features': features,
        'gateway_plan_id': gatewayPlanId,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_trial_plan': isTrialPlan,
      };
}
