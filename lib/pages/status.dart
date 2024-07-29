import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}' )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.message_outlined),
        onPressed: () {
          socketService.socket.emit('emitir-mensaje', { 
            'nombre': 'FLUTTER', 
            'mensaje': 'Hola desde Flutter'
          });
        }
      ),
    );
  }
}