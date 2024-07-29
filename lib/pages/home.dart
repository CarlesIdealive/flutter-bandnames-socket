import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/models/band.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  //ES EL STATE DEL STATEFUL WIDGET
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload){
    // print('Recargndo bandas');
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }


  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Declaracio del Provider
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Names',style: TextStyle( color: Colors.black38), textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: 
              socketService.serverStatus == ServerStatus.onLine
                ? Icon( Icons.check_circle, color: Colors.blue[300] )
                : const Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context,int index) => _bandTile( bands[index])
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add)
      ),
    );
  }



  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context,listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        deleteBandFromList(band);
        // bands.remove(band);
        // print('direction:  $direction');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color:Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete item', style: TextStyle(color: Colors.white),),
        )
      ),
      child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text( band.name.substring(0,2)),
            ),
            title: Text(band.name),
            trailing: Text('${ band.votes}', style: const TextStyle( fontSize: 20)),
            onTap: () {
              socketService.socket.emit('vote-band', { 'id': band.id } );
            },
          ),
    );
  }


  addNewBand() {
    final textController = new TextEditingController();
    //ANDRIOID
    if ( Platform.isAndroid ){
      return showDialog(
          //En un StateFull Widget el context es global
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: Text('New Band name'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text),
                  child: const Text('Add'),
                )
              ],
            );
          },
      );
    }
    //IOS
    showCupertinoDialog(
      context: context, 
      builder: ( _ ) {
        return CupertinoAlertDialog(
          title: const Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void addBandToList( String name ) {
    if (name.length > 1) {
      //Agregar nueva Banda
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', { 'name': name } );
      // setState(() {});
    }
    Navigator.pop(context);
  }


  void deleteBandFromList( Band band ){

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.emit('delete-band', { 'id': band.id });

  }


  //Funcion que retorna un Widget de GRAFICO
  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!
    ];

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        // centerText: "HYBRID",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      )
    );
  }


}