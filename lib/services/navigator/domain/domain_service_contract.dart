import 'package:health_gauge/services/firebase/model/app_credential.dart';
import 'package:health_gauge/services/navigator/helpers/navigator_utils.dart';
import 'package:health_gauge/services/navigator/page/page_service_contract.dart';

abstract class DomainServiceContract {
  PageServiceContract? getPageServiceContract({EnumPageIntent? pageIntent});

  EnumPageIntent? initialPageIntent();

  var _domainConfig;

  DomainConfig? get domainConfig => _domainConfig;

  set domainConfig(DomainConfig? domainConfig);

  Future<void> performInitialSetup();
}
