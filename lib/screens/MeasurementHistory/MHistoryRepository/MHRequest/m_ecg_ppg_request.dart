class MECGPPGRequest {
  String id;

  MECGPPGRequest({
    required this.id,
  });

  factory MECGPPGRequest.fromJson(Map<String, dynamic> json) {
    return MECGPPGRequest(
      id: json['ID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
    };
  }
}
