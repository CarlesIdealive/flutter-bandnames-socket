import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus { onLine,  offLine,  connecting }


class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  IO.Socket _socket = IO.io('..');

  //GETTERS
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService(){
    _initConfig();
  }



  void _initConfig() {
   // Dart client
    _socket = IO.io('http://192.168.1.54:3001/', 
      IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .build()
    );

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.onLine;
      //Notificar un cambio de Estado
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });


    // socket.on('nuevo-mensaje', ( payload ) {
    //   print('Nuevo mensaje:');
    //   print('nombre:' + payload['nombre']);
    //   print( payload.containsKey('mensaje') ? payload['mensaje'] : 'No viene man');
    // });

  }



}