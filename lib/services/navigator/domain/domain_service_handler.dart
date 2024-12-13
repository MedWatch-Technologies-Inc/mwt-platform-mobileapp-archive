import 'package:health_gauge/services/navigator/helpers/navigator_utils.dart';

import 'domain_service_contract.dart';

class DomainServiceHandler {
  NavigationDomains domain;

  DomainServiceHandler(this.domain);

  DomainServiceContract? getDomainService() {
    DomainServiceContract? domainServiceContract;
    switch (domain) {
      case NavigationDomains.common:
        break;
      case NavigationDomains.home:
        break;
    }

    return domainServiceContract;
  }
}
