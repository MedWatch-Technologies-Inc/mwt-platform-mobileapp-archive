import 'package:json_annotation/json_annotation.dart';

part 'app_credential.g.dart';

@JsonSerializable()
class AppCredential {
  @JsonKey(name: 'modelConfig')
  List<ModelConfig>? modelConfig;

  @JsonKey(name: 'appConfig')
  AppConfig? appConfig;

  @JsonKey(name: 'domainConfig')
  Map<String, DomainConfig>? domainConfig;

  AppCredential({
    this.modelConfig,
    this.appConfig,
    this.domainConfig,
  });

  factory AppCredential.fromJson(Map<String, dynamic> srcJson) =>
      _$AppCredentialFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AppCredentialToJson(this);
}

@JsonSerializable()
class ModelConfig {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'code')
  int? code;

  @JsonKey(name: 'supportedMlModels')
  List<SupportedMlModel>? supportedMlModels;

  ModelConfig({
    this.name,
    this.code,
    this.supportedMlModels,
  });

  factory ModelConfig.fromJson(Map<String, dynamic> srcJson) =>
      _$ModelConfigFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModelConfigToJson(this);
}

@JsonSerializable()
class SupportedMlModel extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'destination_path')
  String? destinationPath;

  @JsonKey(name: 'model_type')
  String? modelType;

  @JsonKey(name: 'versions')
  List<ModelInfo>? versions;

  SupportedMlModel(
    this.name,
    this.destinationPath,
    this.modelType,
    this.versions,
  );

  factory SupportedMlModel.fromJson(Map<String, dynamic> srcJson) =>
      _$SupportedMlModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SupportedMlModelToJson(this);
}

@JsonSerializable()
class ModelInfo extends Object {
  @JsonKey(name: 'version')
  int? version;

  @JsonKey(name: 'url')
  String? url;

  ModelInfo(
    this.version,
    this.url,
  );

  factory ModelInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$ModelInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModelInfoToJson(this);
}

@JsonSerializable()
class AppConfig {
  AppConfig();

  factory AppConfig.fromJson(Map<String, dynamic> srcJson) =>
      _$AppConfigFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}

@JsonSerializable()
class DomainConfig {
  @JsonKey(name: 'credentials')
  Map<String, dynamic>? credentials;

  @JsonKey(name: 'enabled')
  bool? enabled;

  @JsonKey(name: 'name')
  String? name;

  DomainConfig({
    this.credentials,
    this.enabled,
    this.name,
  });

  factory DomainConfig.fromJson(Map<String, dynamic> srcJson) =>
      _$DomainConfigFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DomainConfigToJson(this);
}

@JsonSerializable()
class Credentials {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'value')
  String? value;

  Credentials({
    this.name,
    this.value,
  });

  factory Credentials.fromJson(Map<String, dynamic> srcJson) =>
      _$CredentialsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);
}
