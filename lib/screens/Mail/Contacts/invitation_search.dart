import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/pending_invitation_model.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/screens/inbox/invitation_search_bloc.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class InvitationSearch extends StatefulWidget {
  final List<InvitationList>? invitations;

  InvitationSearch({this.invitations});

  @override
  _InvitationSearchState createState() => _InvitationSearchState();
}

class _InvitationSearchState extends State<InvitationSearch> {
  List<InvitationList> dataList = [];
  late TextEditingController _searchController;
  InvitationSearchBloc? bloc;

  List<InvitationList> searchList(String query) {
    List<InvitationList> dataList = [];
    for (var v in widget.invitations!) {
      if (v.senderFirstName!.toUpperCase().contains(query.toUpperCase()) ||
          v.senderLastName!.toUpperCase().contains(query.toUpperCase()) ||
          "${v.senderFirstName!.toUpperCase()} ${v.senderLastName!.toUpperCase()}"
              .contains(query.toUpperCase())) {
        dataList.add(v);
      }
    }
    return dataList;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    bloc = BlocProvider.of<InvitationSearchBloc>(context);

    dataList = searchList('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.graydark),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
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
              hintText: StringLocalization.of(context)
                  .getText(StringLocalization.searchContact),
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: AppColor.graydark,
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
        child: Column(
          children: <Widget>[
            BlocListener(
              bloc: bloc,
              listener: (BuildContext context, InboxState state) {
                if (state is AcceptRejectInvitationSucessState) {
                  if (state.response.result!) {
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text(state.response.message),
                    // ));
                    CustomSnackBar.buildSnackbar(
                        context, state.response.message!, 3);
                  }
                }
              },
              child: Container(),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              child: CachedNetworkImage(
                                imageUrl: dataList[index].senderPicture ?? '',
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "asset/m_profile_icon.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Text(
                              '${dataList[index].senderFirstName} ${dataList[index].senderLastName}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                            Spacer(flex: 6),
                            CircleAvatar(
                              backgroundColor: AppColor.green,
                              child: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: AppColor.white,
                                ),
                                onPressed: () {
                                  bloc?.add(AcceptRejectInvitation(
                                      contactId: dataList[index].contactID,
                                      isAccepted: true));
                                  setState(() {
                                    dataList.removeAt(index);
                                  });

                                  widget.invitations?.removeAt(index);
                                },
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            CircleAvatar(
                              backgroundColor: AppColor.green,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppColor.white,
                                ),
                                onPressed: () {
                                  bloc?.add(AcceptRejectInvitation(
                                      contactId: dataList[index].contactID,
                                      isAccepted: false));
                                  setState(() {
                                    dataList.removeAt(index);
                                  });
                                  widget.invitations?.removeAt(index);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
