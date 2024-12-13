class CollectEcgModel{
  num? collectDigits;
  num? collectType;
  num? collectSN;
  num? collectTotalLen;
  num? collectSendTime;
  num? collectStartTime;
  num? collectBlockNum;
  List? ecgData;

  CollectEcgModel();

  CollectEcgModel.fromMap(Map map){
    if(map['collectDigits'] is num){
      collectDigits = map['collectDigits'];
    }
    if(map['collectType'] is num){
      collectType = map['collectType'];
    }
    if(map['collectSN'] is num){
      collectSN = map['collectSN'];
    }
    if(map['collectTotalLen'] is num){
      collectTotalLen = map['collectTotalLen'];
    }
    if(map['collectSendTime'] is num){
      collectSendTime = map['collectSendTime'];
    }
    if(map['collectStartTime'] is num){
      collectStartTime = map['collectStartTime'];
    }
    if(map['collectBlockNum'] is num){
      collectBlockNum = map['collectBlockNum'];
    }
    if(map['ecgData'] is List){
      ecgData = map['ecgData'];
    }
  }

  @override
  String toString() {
    return 'CollectEcgModel{collectDigits: $collectDigits, collectType: $collectType, collectSN: $collectSN, collectTotalLen: $collectTotalLen, collectSendTime: $collectSendTime, collectStartTime: $collectStartTime, collectBlockNum: $collectBlockNum, ecgData: $ecgData}';
  }
}