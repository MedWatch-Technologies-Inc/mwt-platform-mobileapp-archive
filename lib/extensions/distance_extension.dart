extension DistanceExtension on double {
  double convertDistanceToUserUnit(bool isMile) {
    if (isMile) {
      return this * 0.621371;
    }
    return this;
  }
}
