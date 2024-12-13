import 'package:health_gauge/ui/graph_screen/manager/step_data_process.dart';
import 'package:health_gauge/utils/gloabals.dart';

import '../graph_item_data.dart';
import 'graph_item_enum.dart';
import 'graph_type_model.dart';
import 'health_kit_or_google_fit_data_process.dart';
import 'sub_data_process.dart';
import 'tag_data_process.dart';
import 'weight_data_process.dart';



class GraphDataManager {
  //Function to gather and process measurement data
  //it takes parameters as signals,start and end date,is the data requested for day or week or month

  // function to get Tagnote data

  //GraphManager function to manage data from the above function and append all the graph data into single list
  Future<List<GraphItemData>> graphManager({required String userId, required DateTime startDate, required DateTime endDate, required List selectedGraphTypes, required bool isEnableNormalize, required int unitType}) async {
    var dataList = <GraphItemData>[];
    if(selectedGraphTypes.isNotEmpty){
      for(var i=0;i<selectedGraphTypes.length;i++){
        GraphTypeModel model = selectedGraphTypes[i];
        try {
                  var items = <GraphItemData>[];

                  //get tag data
                  if(model.tableName == DefaultGraphItem.tag.tableName){
                    var tagData = TagDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:model.fieldName,isEnableNormalize: isEnableNormalize);
                    items = await tagData.getData();
                  }

                  //get google and health kit
                  else if(model.tableName == DefaultGraphItem.healthKitStep.tableName){
                    var data = HealthKitOrGoogleFitDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName: model.fieldName ,isEnableNormalize: isEnableNormalize);
                    items = await data.getData();
                  }

                  //get tag data
                  else if(model.tableName == DefaultGraphItem.step.tableName){
                    var data = StepDataProcess(startDate: startDate, endDate: endDate, userId: userId, fieldName: model.fieldName, tableName: model.tableName,isEnableNormalize:isEnableNormalize);
                    items = await data.getData();
                  }

                  //get weight data
                  else if(model.tableName == DefaultGraphItem.weight.tableName){
                    var weightData = WeightDataProcess(startDate: startDate, endDate: endDate, userId: userId, fieldName: model.fieldName, tableName: model.tableName,isEnableNormalize:isEnableNormalize);
                    items = await weightData.getData();
                    if(unitType == 2 && (model.fieldName == 'WeightSum' || model.fieldName == 'BoneMass')){
                      for (var element in items) {
                        // element.yValue = (element.yValue * 2.205);
                        element.yValue = (element.yValue * 2.20462);
                      }
                    }
                  }

                  //get other data
                  else {
                    var data = SubDataProcess(startDate: startDate, endDate: endDate, userId: userId, fieldName: model.fieldName, tableName: model.tableName,isEnableNormalize:isEnableNormalize);
                    items = await data.getData();
                    if(model.fieldName == 'Temperature'){
                      items.removeWhere((element) => element.yValue <= 1);
                      if(tempUnit == 1) {
                        for (var element in items) {
                          element.yValue =  element.yValue * (9/5) + 32;
                        }
                      }
                    }
                  }

                  if (items.isNotEmpty) {
                    dataList.addAll(items);
                  }
        } catch (e) {
          print(e);
        }
      }
    }

    /*SubDataProcess hrData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'approxHr',tableName:'Measurement');
    SubDataProcess hrvData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'hrv',tableName:'Measurement');
    SubDataProcess sbpData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'approxSBP',tableName:'Measurement');
    SubDataProcess dbpData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'approxDBP',tableName:'Measurement');
    SubDataProcess stepsData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'step',tableName:'Sport');
    SubDataProcess caloriesData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'calories',tableName:'Sport');
    SubDataProcess distanceData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'distance',tableName:'Sport');
    SubDataProcess lightSleepTimeData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'allTime',tableName:'Sleep');
    SubDataProcess deepSleepTimeData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'deepTime',tableName:'Sleep');
    SubDataProcess totalSleepTimeData = SubDataProcess(startDate: startDate, endDate:endDate, userId :userId ,fieldName:'sleepAllTime',tableName:'Sleep');


    List<GraphItemData> hrItems = await hrData.getData();
    List<GraphItemData> hrvItems = await hrvData.getData();
    List<GraphItemData> sbpItems = await sbpData.getData();
    List<GraphItemData> dbpItems = await dbpData.getData();
    List<GraphItemData> stepsItems = await stepsData.getData();
    List<GraphItemData> caloriesItems = await caloriesData.getData();
    List<GraphItemData> distanceItems = await distanceData.getData();
    List<GraphItemData> lightSleepTimeItems = await lightSleepTimeData.getData();
    List<GraphItemData> deepSleepTimeItems = await deepSleepTimeData.getData();
    List<GraphItemData> totalSleepTimeItems = await totalSleepTimeData.getData();
*/
 /*   if(getAllData != null && getAllData){
      List<GraphItemData> dataList = [];

        dataList.addAll(hrItems);
        dataList.addAll(hrvItems);
        dataList.addAll(sbpItems);
        dataList.addAll(dbpItems);
        dataList.addAll(stepsItems);
        dataList.addAll(caloriesItems);
        dataList.addAll(distanceItems);
        dataList.addAll(lightSleepTimeItems);
        dataList.addAll(deepSleepTimeItems);
        dataList.addAll(totalSleepTimeItems);

        return dataList;
    }
*/
    return dataList;
  }
}
