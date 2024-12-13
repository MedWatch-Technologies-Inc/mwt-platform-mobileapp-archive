class HRVCalc {
  static final HRVCalc _singleton = HRVCalc._internal();

  factory HRVCalc() {
    return _singleton;
  }

  HRVCalc._internal();

  List<int> hrvBuffer = [];
  num sum = 0;
  int windowSize = 4;

  void resetData(){
    hrvBuffer = [];
    sum = 0;
    windowSize = 3;
  }

  void addHRV(int hrv) {
    hrvBuffer.insert(hrvBuffer.length, hrv);
    sum += hrv;

    if (hrvBuffer.length > windowSize) {
      var removedHRV = hrvBuffer.removeAt(0);
      sum -= removedHRV;
    }

    print('AddHRV :: HRV :: $hrv :: HRVBuffer :: $hrvBuffer -> ${hrvBuffer.length}');
    print('AddHRV :: SUM :: $sum :: RNAverage :: $runningHRVAverage');
  }

  double get runningHRVAverage => hrvBuffer.isEmpty ? 0.0 : sum / hrvBuffer.length;
}
