class RazorpayPlansResponse {
  final String? entity;
  final int? count;
  final List<PlanItem>? items;

  RazorpayPlansResponse({
    this.entity,
    this.count,
    this.items,
  });

  factory RazorpayPlansResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayPlansResponse(
      entity: json['entity'] as String?,
      count: json['count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => PlanItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'entity': entity,
        'count': count,
        'items': items?.map((x) => x.toJson()).toList(),
      };
}

class PlanItem {
  final String? id;
  final String? entity;
  final int? interval;
  final String? period;
  final RazorpayItem? item;
  final List<dynamic>? notes;
  final int? createdAt;

  PlanItem({
    this.id,
    this.entity,
    this.interval,
    this.period,
    this.item,
    this.notes,
    this.createdAt,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    return PlanItem(
      id: json['id'] as String?,
      entity: json['entity'] as String?,
      interval: json['interval'] as int?,
      period: json['period'] as String?,
      item: json['item'] != null
          ? RazorpayItem.fromJson(json['item'])
          : null,
      notes: json['notes'] as List<dynamic>?,
      createdAt: json['created_at'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'entity': entity,
        'interval': interval,
        'period': period,
        'item': item?.toJson(),
        'notes': notes,
        'created_at': createdAt,
      };
}

class RazorpayItem {
  final String? id;
  final bool? active;
  final String? name;
  final String? description;
  final int? amount;
  final int? unitAmount;
  final String? currency;
  final String? type;
  final String? unit;
  final bool? taxInclusive;
  final String? hsnCode;
  final String? sacCode;
  final double? taxRate;
  final String? taxId;
  final String? taxGroupId;
  final int? createdAt;
  final int? updatedAt;

  RazorpayItem({
    this.id,
    this.active,
    this.name,
    this.description,
    this.amount,
    this.unitAmount,
    this.currency,
    this.type,
    this.unit,
    this.taxInclusive,
    this.hsnCode,
    this.sacCode,
    this.taxRate,
    this.taxId,
    this.taxGroupId,
    this.createdAt,
    this.updatedAt,
  });

  factory RazorpayItem.fromJson(Map<String, dynamic> json) {
    return RazorpayItem(
      id: json['id'] as String?,
      active: json['active'] as bool?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as int?,
      unitAmount: json['unit_amount'] as int?,
      currency: json['currency'] as String?,
      type: json['type'] as String?,
      unit: json['unit'] as String?,
      taxInclusive: json['tax_inclusive'] as bool?,
      hsnCode: json['hsn_code'] as String?,
      sacCode: json['sac_code'] as String?,
      taxRate: (json['tax_rate'] as num?)?.toDouble(),
      taxId: json['tax_id'] as String?,
      taxGroupId: json['tax_group_id'] as String?,
      createdAt: json['created_at'] as int?,
      updatedAt: json['updated_at'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'active': active,
        'name': name,
        'description': description,
        'amount': amount,
        'unit_amount': unitAmount,
        'currency': currency,
        'type': type,
        'unit': unit,
        'tax_inclusive': taxInclusive,
        'hsn_code': hsnCode,
        'sac_code': sacCode,
        'tax_rate': taxRate,
        'tax_id': taxId,
        'tax_group_id': taxGroupId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
