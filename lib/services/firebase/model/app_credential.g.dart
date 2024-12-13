// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCredential _$AppCredentialFromJson(Map json) => AppCredential(
      modelConfig: (json['modelConfig'] as List<dynamic>?)
          ?.map(
              (e) => ModelConfig.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      appConfig: json['appConfig'] == null
          ? null
          : AppConfig.fromJson(
              Map<String, dynamic>.from(json['appConfig'] as Map)),
      domainConfig: (json['domainConfig'] as Map?)?.map(
        (k, e) => MapEntry(k as String,
            DomainConfig.fromJson(Map<String, dynamic>.from(e as Map))),
      ),
    );

Map<String, dynamic> _$AppCredentialToJson(AppCredential instance) =>
    <String, dynamic>{
      'modelConfig': instance.modelConfig?.map((e) => e.toJson()).toList(),
      'appConfig': instance.appConfig?.toJson(),
      'domainConfig':
          instance.domainConfig?.map((k, e) => MapEntry(k, e.toJson())),
    };

ModelConfig _$ModelConfigFromJson(Map json) => ModelConfig(
      name: json['name'] as String?,
      code: json['code'] as int?,
      supportedMlModels: (json['supportedMlModels'] as List<dynamic>?)
          ?.map((e) =>
              SupportedMlModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$ModelConfigToJson(ModelConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'supportedMlModels':
          instance.supportedMlModels?.map((e) => e.toJson()).toList(),
    };

SupportedMlModel _$SupportedMlModelFromJson(Map json) => SupportedMlModel(
      json['name'] as String?,
      json['destination_path'] as String?,
      json['model_type'] as String?,
      (json['versions'] as List<dynamic>?)
          ?.map((e) => ModelInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SupportedMlModelToJson(SupportedMlModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'destination_path': instance.destinationPath,
      'model_type': instance.modelType,
      'versions': instance.versions?.map((e) => e.toJson()).toList(),
    };

ModelInfo _$ModelInfoFromJson(Map json) => ModelInfo(
      json['version'] as int?,
      json['url'] as String?,
    );

Map<String, dynamic> _$ModelInfoToJson(ModelInfo instance) => <String, dynamic>{
      'version': instance.version,
      'url': instance.url,
    };

AppConfig _$AppConfigFromJson(Map json) => AppConfig();

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) =>
    <String, dynamic>{};

DomainConfig _$DomainConfigFromJson(Map json) => DomainConfig(
      credentials: (json['credentials'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e),
      ),
      enabled: json['enabled'] as bool?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DomainConfigToJson(DomainConfig instance) =>
    <String, dynamic>{
      'credentials': instance.credentials,
      'enabled': instance.enabled,
      'name': instance.name,
    };

Credentials _$CredentialsFromJson(Map json) => Credentials(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$CredentialsToJson(Credentials instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
