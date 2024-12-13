class SyncDB {
  static final SyncDB _singleton = SyncDB._internal();

  factory SyncDB() {
    return _singleton;
  }

  SyncDB._internal();


}
