import 'package:flutter/material.dart';
import 'package:names_band/services/socket_service.dart';

import 'package:provider/provider.dart';

import 'package:names_band/pages/home.dart';
import 'package:names_band/pages/status.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home' : (_) => HomePage(),
          'status':(_) => StatusPage()
        },
      ),
    );
  }
}