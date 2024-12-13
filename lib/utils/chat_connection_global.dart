import 'dart:async';
import 'package:health_gauge/utils/constants.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatConnectionGlobal {
  static final ChatConnectionGlobal? _singleton =
      ChatConnectionGlobal._internal();

  factory ChatConnectionGlobal() {
    return _singleton!;
  }

  ChatConnectionGlobal._internal();
  String url = '${Constants.baseHost}chathub';
  HubConnection? hubConnection;
  // ChatConnectionState connectionState = ChatConnectionState.DISCONNECTED;
  String connectionId = '';

  final onStatusChange = StreamController<ChatConnectionState>.broadcast();

  Stream<ChatConnectionState> get connectionStatus => onStatusChange.stream;

  final _onMsgReceive = StreamController<List>.broadcast();

  Stream<List> get newMsg => _onMsgReceive.stream;
  var builder = HubConnectionBuilder();

  Future<void> connectToHub() async {
    try {
      // builder.withAutomaticReconnect([500, 1000, 2000]);
      hubConnection?.stop();

      hubConnection = null;
      connectionId = "";

      // hubConnection = HubConnectionBuilder()
      hubConnection = builder
          .withUrl(
              url,
              HttpConnectionOptions(
                logMessageContent: true,
                skipNegotiation: false,
                transport: HttpTransportType.webSockets,
                logging: (level, message) => print(
                    'Chat Logggggs :: message#  ${message.toString()} :: level# ${level.toString()}'),
              ))
          .build();
      await hubConnection?.start();

      if (hubConnection?.state == HubConnectionState.connected) {
        print('Chat Loggggg :: connected');

        // connectionState = ChatConnectionState.CONNECTED;
        onStatusChange.add(ChatConnectionState.CONNECTED);

        print(hubConnection?.connectionId.toString());
        print(hubConnection?.baseUrl.toString());

        connectionId = hubConnection?.connectionId ?? '';
      }
      hubConnection?.onclose((error) async {
        print('Chat Loggggg :: onclose ${error.toString()}');
        // print("Connection Closed $error");
        // print("chat event mapEventToState: $error ");
        // connectionState = ChatConnectionState.DISCONNECTED;
        onStatusChange.add(ChatConnectionState.DISCONNECTED);
        hubConnection?.off('sendchat');
        hubConnection?.stop();
        hubConnection = null;
        connectionId = "";
        // await hubConnection?.start();
        connectToHub();
      });
      hubConnection?.onreconnected((cId) {
        connectionId = cId ?? '';
        print('Chat Loggggg :: onreconnected ${cId.toString()}');

        onStatusChange.add(ChatConnectionState.CONNECTED);
      });
      hubConnection?.onreconnecting((exception) {
        print('Chat Loggggg :: onreconnecting ${exception.toString()}');
        hubConnection?.off('sendchat');
        hubConnection?.stop();
        hubConnection = null;
        connectionId = "";
        // print('chat event mapEventToState: DISCONNECTED ');
        // connectionState = ChatConnectionState.DISCONNECTED;
        onStatusChange.add(ChatConnectionState.DISCONNECTED);
      });

      ChatConnectionGlobal().hubConnection?.on("sendchat", (messages) {
        print('Chat Loggggg :: sendchat ${messages.toString()}');

        _onMsgReceive.add(messages ?? []);
      });
    } catch (e) {
      print('Chat Loggggg :: catch ${e.toString()}');
      hubConnection?.off('sendchat');
      hubConnection?.stop();
      hubConnection = null;
      connectionId = "";
      builder = HubConnectionBuilder();




      // connectionState = ChatConnectionState.DISCONNECTED;
      onStatusChange.add(ChatConnectionState.DISCONNECTED);
     // print(e);
    }
  }
}

enum ChatConnectionState { CONNECTED, CONNECTING, DISCONNECTED }
