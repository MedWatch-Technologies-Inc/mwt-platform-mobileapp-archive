// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map json) => ImageModel(
      id: json['ID'] as int?,
      fileName: json['FileName'] as String?,
      fileContent: json['FileContent'] as String?,
      filePath: json['FileFath'] as String?,
    );

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'FileName': instance.fileName,
      'FileContent': instance.fileContent,
      'FileFath': instance.filePath,
    };
