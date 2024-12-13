import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/Mail/Contacts/contacts_screen.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/pages/chat_page.dart';
import 'package:health_gauge/screens/chat/pages/group_list_page.dart';
import 'package:health_gauge/utils/chat_connection_global.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/custom_floating_action_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

import 'chat_contacts_page.dart';
import 'create_group_page.dart';
import 'group_chat_page.dart';

class ChatTabPageEnter extends StatefulWidget {
  final userId;

  ChatTabPageEnter(this.userId);

  @override
  _ChatTabPageState createState() => _ChatTabPageState();
}

class _ChatTabPageState extends State<ChatTabPageEnter> {
  @override
  void initState() {
    print('Chat Loggggg :: initState');
    if (ChatConnectionGlobal().connectionId.isEmpty) {
      print('Chat Loggggg :: initState Call connectToHub');
      ChatConnectionGlobal().connectToHub();
    }
    super.initState();
  }

  // @override
  // void dispose() {
  // Its not calling . It calling under the page
  //   // TODO: implement dispose
  //   print('Chat Loggggg :: dispose');
  //   ChatConnectionGlobal().connectionId = "";
  //   ChatConnectionGlobal().hubConnection?.off('sendchat');
  //   ChatConnectionGlobal().hubConnection?.stop();
  //   ChatConnectionGlobal().hubConnection = null;
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ChatBloc(ChatLoading()),
        child: Contacts(
          userId: widget.userId,
          isChat: true,
          // sendMail: sendMail,
        ),
      ),
    );
  }
}
