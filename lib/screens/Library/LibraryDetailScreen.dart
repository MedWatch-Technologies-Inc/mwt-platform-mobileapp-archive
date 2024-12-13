import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/library_models/library_list.dart';
import 'package:health_gauge/screens/Library/LibraryWebView.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class LibraryDetailScreen extends StatefulWidget {
  final String? userId;
  final int? libraryId;
  final String? title;
  final String? folderPath;
  int? pID;

  LibraryDetailScreen(
      {this.title, this.userId, this.libraryId, this.folderPath, this.pID});

  @override
  _LibraryDetailScreenState createState() => _LibraryDetailScreenState();
}

class _LibraryDetailScreenState extends State<LibraryDetailScreen> {
  bool isSearchOpen = false;
  late TextEditingController _searchController;
  late TextEditingController _createFolderController;
  String initValue = 'Untitled Folder';
  String sortBy = 'Name';
  IconData icon = Icons.arrow_upward;
  List<LibraryList> dataList = [];
  LibraryBloc? libraryBloc;
  List<List<int>> libraryIdList = [];
  List<int> parentIdList = [];
  int exapmle = 35;

  @override
  void initState() {
    super.initState();
    _createFolderController = TextEditingController(text: initValue);
    _createFolderController.selection = new TextSelection(
      baseOffset: 0,
      extentOffset: initValue.length,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libraryBloc = BlocProvider.of<LibraryBloc>(context);
    libraryBloc!.add(FetchLibraryEvent(
      userId: widget.userId,
      libraryId: widget.libraryId,
      pageId: 1,
    ));
  }

  Widget searchTextField() {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: TextField(
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
              hintText: 'Search in Drive',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
//                color: AppColor.graydark,
              )),
          onSubmitted: (value) {},
        ));
  }

  _createContainerForOpeningSorting(title, sortby) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          print("clicked $title");
          Navigator.of(context).pop();
          setState(() {
            sortBy = title;
          });
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: sortBy == title
                  ? AppColor.primaryColor.withOpacity(0.3)
                  : null,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              sortby == title
                  ? Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: sortby == title ? AppColor.primaryColor : null,
                    )
                  : Container(
                      width: 18,
                    ),
              SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: sortby == title ? AppColor.primaryColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomActionSheetForSorting() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                padding: const EdgeInsets.only(left: 12.0, top: 10.0),
                child: Text(
                  'Sort By',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              _createContainerForOpeningSorting('Name', sortBy),
              _createContainerForOpeningSorting('Last modified', sortBy),
              _createContainerForOpeningSorting('Last modified by me', sortBy),
              _createContainerForOpeningSorting('Last opened by me', sortBy),
            ],
          ),
        );
      },
    );
  }

  deleteDialog(String userId, int dLibraryId, int libraryId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text('Delete ?'), actions: <Widget>[
            TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  libraryBloc!.add(LibraryDeleteFolderEvent(
                    userId: widget.userId,
                    deleteLibraryId: dLibraryId,
                    libraryId: libraryId,
                  ));
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: AppColor.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ]);
        });
  }

  _createContainer(
      String name, IconData icon, int dLibraryId, Function dDialog) {
    return Container(
      child: GestureDetector(
        onTap: () {
          print("clicked $name");
          deleteDialog(widget.userId!, dLibraryId, widget.libraryId!);
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: AppColor.primaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomActionSheetForDetail(String name, int dLibraryId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              _createContainer('Share', Icons.share, 0, () {}),
              _createContainer(
                  'Remove', Icons.delete, dLibraryId, deleteDialog),
            ],
          ),
        );
      },
    );
  }

  _showBottomActionSheetForAddingFolderAndUpload() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Create new',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Clicked Folder");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(stringLocalization
                                  .getText(StringLocalization.createFolder)),
                              content: Container(
                                child: TextField(
                                  controller: _createFolderController,
                                  decoration: InputDecoration(hintText: ''),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "Create",
                                    style:
                                    TextStyle(color: AppColor.primaryColor),
                                  ),
                                  onPressed: () {
                                    libraryBloc!.add(LibraryCreateFolderEvent(
                                      userId: widget.userId,
                                      libraryId: widget.libraryId,
                                      folderName: _createFolderController.text,
                                      folderPath: widget.folderPath,
                                    ));
                                    _createFolderController =
                                        TextEditingController(text: initValue);
                                    _createFolderController.selection =
                                    new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: initValue.length,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: AppColor.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),

                              ],
                            );
                          });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(
                            Icons.folder,
                            color: AppColor.primaryColor,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        Text('Folder'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Clicked file upload");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(Icons.file_upload,
                              color: AppColor.primaryColor),
                          backgroundColor: Colors.transparent,
                        ),
                        Text('Upload'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        "!!!!!!!!!!!!---------------initial pID---------------!!!!!!!!!!!!!! ${widget.pID} ");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title!),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
//              libraryIdList.removeLast();
//            print("parent ID : $parentIdList");
              libraryBloc = BlocProvider.of<LibraryBloc>(context);
              libraryBloc!.add(FetchLibraryEvent(
                userId: widget.userId,
//                libraryId: parentIdList.indexOf(parentIdList.length-2),//[0,59,62]
                libraryId: widget.pID,
                pageId: 1,
              ));
//              if(parentIdList.length>1)
//                parentIdList.removeLast();//[0,59]
//              print('--------------after removed--------------');
//              print(parentIdList);
              Navigator.of(context).pop();
            });
          },
        ),
        actions: <Widget>[
          isSearchOpen
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSearchOpen = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearchOpen = true;
                    });
                  },
                ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            isSearchOpen ? searchTextField() : Container(),
            BlocListener(
              bloc: libraryBloc,
              listener: (context, state) {
                if (state is LibraryFolderCreateSuccessState) {
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Created Folder Successfully')));
                  CustomSnackBar.buildSnackbar(
                      context, 'Created Folder Successfully', 3);
                } else if (state is LibraryFolderDeleteSuccessState) {
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Deleted Folder/File Successfully')));
                  CustomSnackBar.buildSnackbar(
                      context, 'Deleted Folder/File Successfully', 3);
                }
              },
              child: Container(),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  _openBottomActionSheetForSorting();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Text(sortBy),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        icon,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
              print("inside librarydetailscreen.dart file");
              if (state is LibraryIsLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LibraryIsLoadedState) {
                if (state.libraryDetailModel!.result!) {
                  //home->ross[0]
//                      int pId = state.libraryDetailModel.data!=null?state.libraryDetailModel.data[0].parentID:0;
//                      parentIdList.add(pId);//[0,59,62]
//                      exapmle = 50;
//                      print("example  !!!!!!!!!!!!!!!!!!!!!!!!!! $exapmle ");
//                      print("parent di changed !!!!!!!!!!!!!!!!!!!!!!!!!! $parentIdList ");
                  dataList = state.libraryDetailModel!.data!.reversed.toList();
//                      List<int> libList = [];
//                      for(int i=0;i<dataList.length;i++){
//                        libList.add(dataList[i].libraryID);
//                      }
//                      libraryIdList.add(libList);

                  print("------------------------------");
                  print(parentIdList);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: StringLocalization.of(context)
                                  .getText(StringLocalization.delete),
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                // do something
                                deleteDialog(
                                    widget.userId!,
                                    dataList[index].libraryID!,
                                    widget.libraryId!);
                              },
                            ),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              // go to detail of the folder
                              // if file then open the file
                              if (dataList[index].isFolder!) {
                                // open folder navigate to detail page
                                print("Open Detail Page");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LibraryDetailScreen(
                                          userId: widget.userId,
                                          libraryId: dataList[index].libraryID,
                                          title:
                                              dataList[index].virtualFilePath,
                                          folderPath:
                                              dataList[index].physicalFilePath,
                                          pID: dataList[index].parentID,
                                        )));
                              } else {
                                // open file
                                print("Opening File");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LibraryWebView(
                                        title: dataList[index].virtualFilePath!,
                                        url: dataList[index]
                                            .physicalFilePath!)));
                              }
                            },
                            child: Card(
                              child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    child: Icon(
                                      dataList[index].isFolder!
                                          ? Icons.folder
                                          : Icons.insert_drive_file,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  title: Text(dataList[index].virtualFilePath!),
                                  subtitle:
                                      Text(dataList[index].createdDateTime!),
                                  trailing: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      _openBottomActionSheetForDetail(
                                        dataList[index].virtualFilePath!,
                                        dataList[index].libraryID!,
                                      );
                                    },
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(stringLocalization
                        .getText(StringLocalization.noRecordsFound)),
                  );
                }
              } else {
                return Text(stringLocalization
                    .getText(StringLocalization.oopsDoSomething));
              }
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showBottomActionSheetForAddingFolderAndUpload();
        },
      ),
    );
  }
}
