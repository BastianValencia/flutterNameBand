import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:names_band/models/band.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 10),
    Band(id: '2', name: 'Iron Maiden', votes: 12),
    Band(id: '3', name: 'AC/DC', votes: 11),
    Band(id: '4', name: 'Led Zeppelin', votes: 15),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('BandNames', style: TextStyle( color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) { 
          return _bandTile(bands[i]);
         },
        
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('direccion: $direction');
        print('id: ${band.id}');
        //llamar el borrado en el server
      },
      background: Container(
        padding: EdgeInsets.only(left:10.0),
        color: Colors.red,
        child: Align(
          child: Text('Eliminar Banda', style: TextStyle(color: Colors.white)),
          alignment: Alignment.centerLeft),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
            onTap: (){
              print(band.name);
            },
          ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();


    if(Platform.isAndroid){

    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Nueva Banda'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Agregar'),
                onPressed: (){
                  addBandToList(textController.text);
                },
                elevation: 5,
                textColor: Colors.blue,
              )
            ],
          );
        }
      );

    }else{
      if(Platform.isIOS){
        showCupertinoDialog(
          context: context, 
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text('Nueva Banda: '),
              content: CupertinoTextField(
                controller: textController
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Agregar'),
                  isDefaultAction: true,
                  onPressed: () => addBandToList(textController.text),
                ),
                CupertinoDialogAction(
                  child: Text('Cancelar'),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          }
        );
      }
    }


  }

  void addBandToList(String name){
    print(name);
    if(name.length > 1){
      //Agregamos
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));

      setState(() {});

    }

    Navigator.pop(context);
  }
}

