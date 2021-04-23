import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:names_band/models/band.dart';
import 'package:names_band/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 10),
    // Band(id: '2', name: 'Iron Maiden', votes: 12),
    // Band(id: '3', name: 'AC/DC', votes: 11),
    // Band(id: '4', name: 'Led Zeppelin', votes: 15),
    
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', (data) {
      
      this.bands = (data as List)
      .map((band) => Band.fromMap(band))
      .toList();

      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('BandNames', style: TextStyle( color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online 
            ?Icon(Icons.check_circle, color: Colors.blue[300])
            :Icon(Icons.check_circle, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          _grafica(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) { 
                return _bandTile(bands[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context,listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('id: ${band.id}');
        socketService.socket.emit('delete-band', {'id':band.id});
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
              socketService.socket.emit('vote-band', {'id':band.id});
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name':name});
    }

    Navigator.pop(context);
  }



  Widget _grafica(){
    Map<String, double> dataMap = new Map();
      bands.forEach((band) { 
        dataMap.putIfAbsent(band.name, ()=> band.votes.toDouble());
      });
    
    final List<Color> colorList = [
      Colors.blue[50],
      Colors.blue[200],
      Colors.pink[50],
      Colors.pink[200],
      Colors.yellow[50],
      Colors.yellow[200],
    ];

    return dataMap.isNotEmpty?PieChart(
      dataMap: dataMap, 
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      legendOptions: LegendOptions(
        legendPosition: LegendPosition.right,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      )): LinearProgressIndicator(); 
  }
}

