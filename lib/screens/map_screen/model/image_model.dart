import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel extends Object {
  @JsonKey(name: 'ID')
  int? id;

  @JsonKey(name: 'FileName')
  String? fileName;

  @JsonKey(name: 'FileContent')
  String? fileContent;

  @JsonKey(name: 'FileFath')
  String? filePath;

  ImageModel({
    this.id,
    this.fileName,
    this.fileContent,
    this.filePath,
  });

  factory ImageModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ImageModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}
