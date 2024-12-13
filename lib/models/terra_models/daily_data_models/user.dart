class User {
  User({
    this.provider,
    this.userId,
  });

  User.fromJson(dynamic json) {
    provider = json['provider'];
    userId = json['user_id'];
  }

  String? provider;
  String? userId;

  User copyWith({
    String? provider,
    String? userId,
  }) =>
      User(
        provider: provider ?? this.provider,
        userId: userId ?? this.userId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['provider'] = provider;
    map['user_id'] = userId;
    return map;
  }
}