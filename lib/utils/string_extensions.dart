


extension ExtendedString on String {
  bool isNotEmptyNotNull() {
    return this != null && this.isNotEmpty;
  }

}