import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  //ES EL STATE DEL STATEFUL WIDGET
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5 ),
    Band(id: '2', name: 'Queen', votes: 0 ),
    Band(id: '3', name: 'Bon Jovi', votes: 2 ),
    Band(id: '4', name: 'Sting', votes: 2 ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Names',style: TextStyle( color: Colors.black38), textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context,int index) => _bandTile( bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add)
      ),
    );
  }



  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        //TODO: llamar el borardo en el server
        bands.remove(band);
        print('direction:  $direction');
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
              print(band.name);
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
      //agregamos
      this.bands.add( new Band(
        id: DateTime.now().toString(),
        name: name,
      ));
      setState(() {});
    }
    Navigator.pop(context);

  }




}