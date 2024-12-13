import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

/// Added by: Akhil
/// Added on: July/29/2020
/// This widget is responsible for displaying list of users according to query entered by user
class ContactSearchPage extends StatefulWidget {
  final List<UserData>? searchedContacts;
  final bool? isFromChat;

  ContactSearchPage({this.searchedContacts, this.isFromChat});

  @override
  _ContactSearchPageState createState() => _ContactSearchPageState();
}
/// Added by: Akhil
/// Added on: July/29/2020
/// this class maintains the state of above stateful widget
class _ContactSearchPageState extends State<ContactSearchPage> {
  late TextEditingController _searchController;
  List<UserData> dataList = [];

  /// Added by: Akhil
  /// Added on: July/29/2020
  /// this method to search contacts for query entered by user
  /// @query -  user name text which is to be searched
  /// @return dataList - List of contacts matching the searched result
  List<UserData> searchList(String query) {
    List<UserData> dataList = [];
    for (var v in widget.searchedContacts!) {
      if (v.firstName!.toUpperCase().contains(query.toUpperCase()) ||
          v.lastName!.toUpperCase().contains(query.toUpperCase()) ||
          "${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}"
              .contains(query.toUpperCase())) {
        dataList.add(v);
      }
    }
    return dataList;
  }

  /// Added by: Akhil
  /// Added on: July/29/2020
  ///this is the lifecycle method of stateful widget used to initialize the _searchController
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    dataList = searchList('');
  }
   /// Added by: Akhil
  /// Added on: July/29/2020
  /// this method is responsible for building UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.graydark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: TextField(
          controller: _searchController,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: StringLocalization.of(context).getText(StringLocalization.searchContact),
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              )),
          onChanged: (value) {
            setState(() {
              dataList = searchList(value);
            });
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(dataList[index].picture ?? ''),
                  ),
                  title: Text(
                      '${dataList[index].firstName} ${dataList[index].lastName}'),
                  onTap: (){
                    if(context != null && (widget.isFromChat ?? false)){Navigator.of(context).pop(dataList[index]);}
                  },
                ),
              );
            }),
      ),
    );
  }
}
