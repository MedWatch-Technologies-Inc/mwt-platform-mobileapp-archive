import 'package:charts_flutter/flutter.dart' as chart;
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/value/app_color.dart';
import '../graph_item_data.dart';

class BarGraphData {
  final List<GraphTypeModel> graphList;
  final List<GraphItemData> graphItemList;
  BarGraphData({required this.graphList, required this.graphItemList});

  List<chart.Series<GraphItemData, String>> getBarGraphData(){
    return List.generate(graphList.length, (index) {
      var typeModel = graphList[index];
      var colorCode = '#009C92';
      if (typeModel.color.isNotEmpty) {
        colorCode = typeModel.color;
      }
      var materialColor = HexColor.fromHex(colorCode);

      var list = <GraphItemData>[];
      list = graphItemList
          .where((element) => element.label == typeModel.fieldName)
          .toList();
      list.sort(
              (GraphItemData a, GraphItemData b) => a.xValue.compareTo(b.xValue));
      return chart.Series<GraphItemData, String>(
        id: typeModel.id.toString(),
        colorFn: (GraphItemData data, __) => chart.Color(
            a: materialColor.alpha,
            r: materialColor.red,
            g: materialColor.green,
            b: materialColor.blue),
        domainFn: (GraphItemData data, _) => data.xValue.toInt().toString(),
        measureFn: (GraphItemData data, _) => data.yValue,
        data: list,
      );
    });
  }

}