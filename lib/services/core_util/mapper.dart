abstract class Mapper<Source, Destination> {
  /// Maps data from source data to destination data.
  ///
  /// [sourceData] data that needs to be converted
  Destination? map(Source? sourceData);
}
