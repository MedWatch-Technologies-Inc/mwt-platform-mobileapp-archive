import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeeplinkParameters {
  /// Base dynamic link url
  String get baseUrl => ''; //TODO add base url

  /// Android parameters . It is default and don't change
  AndroidParameters get androidParameters => AndroidParameters(
        packageName: '', //TODO add package name
        minimumVersion: 0,
      );

  /// IOS parameters . It is default and don't change
  IOSParameters get iosParameters => IOSParameters(
        bundleId: '', // TODO add package name
        minimumVersion: '0',
        appStoreId: '', //TODO add appstore id
      );

  /// Social Meta parameters .It is default and don't change
  SocialMetaTagParameters socialMetaTagParameters(
      {String? title, required String imageUrl, String? desc}) {
    return SocialMetaTagParameters(
      description: desc,
      imageUrl: Uri.parse(imageUrl),
      title: title,
    );
  }
}
