import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketHelper {
  String url;
  late IO.Socket _socket;

  SocketHelper(this.url) {
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false
    });
  }

  IO.Socket get socket => _socket;

  void connect({
    VoidCallback? onConnecting,
    VoidCallback? onConnect,
    Function(dynamic)? onConnectError,
    Function(dynamic)? onConnectTimeout,
    VoidCallback? onReconnect,
  }) {
    if (!_socket.connected) {
      _socket.connect();

      if (onConnecting != null) {
        _socket.onConnecting((data) => onConnecting());
      }

      if (onConnect != null) {
        _socket.onConnect((data) => onConnect());
      }

      if (onConnectError != null) {
        _socket.onConnectError(onConnectError);
      }

      if (onConnectTimeout != null) {
        _socket.onConnectTimeout(onConnectTimeout);
      }

      if (onReconnect != null) {
        _socket.onReconnect((data) => onReconnect());
      }
    }
  }

  void disconnect({VoidCallback? onDisconnect}) {
    if (_socket.connected) {
      print('socket_disconnect');
      _socket.disconnect();
      if (onDisconnect != null) {
        _socket.onDisconnect((data) => onDisconnect());
      }
    }
  }

  void dispose() {
    _socket.dispose();
  }

  void listenEvent(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  void emitData(String event, [dynamic data]) {
    if (_socket.connected) {
      _socket.emit(event, data);
    }
  }
}
