class UserDetailsModel {
  final bool? success;
  final Data? data;
  final String? message;

  UserDetailsModel({
    this.success,
    this.data,
    this.message,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      success: json['success'] as bool?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class Data {
  final int? id;
  final String? name;
  final String? email;
  final String? emailVerifiedAt;
  final String? phone;
  final String? levelName;
  final String? purposeName;
  final int? age;
  final String? city;
  final String? pincode;
  final String? address;
  final String? state;
  final String? gender;
  final String? type;
  final String? dateOfBirth;
  final String? time;
  final int? isSubscribed;
  final String? subscriptionStatus;
  final String? deviceToken;
  final String? gatewayCustomerId;
  final String? referralCode;
  final String? referredBy;
  final String? walletBalance;
  final String? createdAt;
  final String? updatedAt;
  final int? isTrialUsed;

  final Level? level;
  final Purpose? purpose;

  Data({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.levelName,
    this.purposeName,
    this.age,
    this.city,
    this.pincode,
    this.address,
    this.state,
    this.gender,
    this.type,
    this.dateOfBirth,
    this.time,
    this.isSubscribed,
    this.subscriptionStatus,
    this.deviceToken,
    this.gatewayCustomerId,
    this.referralCode,
    this.referredBy,
    this.walletBalance,
    this.createdAt,
    this.updatedAt,
    this.level,
    this.purpose,
    this.isTrialUsed,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic v) => v == null ? null : int.tryParse(v.toString());

    return Data(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      phone: json['phone']?.toString(),
      levelName: json['level_name'],
      purposeName: json['purpose_name'],
      age: _parseInt(json['age']),
      city: json['city']?.toString(),
      pincode: json['pincode']?.toString(),
      address: json['address'],
      state: json['state'],
      gender: json['gender'],
      type: json['type'],
      dateOfBirth: json['date_of_birth'],
      time: json['time']?.toString(),
      isSubscribed: _parseInt(json['is_subscribed']),
      subscriptionStatus: json['subscription_status'],
      deviceToken: json['device_token'],
      gatewayCustomerId: json['gateway_customer_id'],
      referralCode: json['referral_code'],
      referredBy: json['referred_by'],
      walletBalance: json['wallet_balance']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isTrialUsed: _parseInt(json['trial_used'] ?? json['is_trial_used']),
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
      purpose: json['purpose'] != null ? Purpose.fromJson(json['purpose']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone': phone,
      'level_name': levelName,
      'purpose_name': purposeName,
      'age': age,
      'city': city,
      'pincode': pincode,
      'address': address,
      'state': state,
      'gender': gender,
      'type': type,
      'date_of_birth': dateOfBirth,
      'time': time,
      'is_subscribed': isSubscribed,
      'subscription_status': subscriptionStatus,
      'device_token': deviceToken,
      'gateway_customer_id': gatewayCustomerId,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'wallet_balance': walletBalance,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'trial_used': isTrialUsed,
      'level': level?.toJson(),
      'purpose': purpose?.toJson(),
    };
  }

  bool get isSubscribedBool => isSubscribed == 1;
  bool get isTrialActive => subscriptionStatus == "trial";
  bool get hasUsedTrial => (isTrialUsed ?? 0) == 1;
}

class Level {
  final int? id;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  Level({this.id, this.name, this.createdAt, this.updatedAt});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Purpose {
  final int? id;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  Purpose({this.id, this.name, this.createdAt, this.updatedAt});

  factory Purpose.fromJson(Map<String, dynamic> json) {
    return Purpose(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
