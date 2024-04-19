import 'package:flutter/material.dart';
import 'login.dart';
import 'viewCoin.dart';
import 'filterCoin.dart';
import 'favoriteCoin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha App de Criptomoedas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/viewCoin': (context) => ViewCoinScreen(),
        '/filterCoin': (context) => FilterCoinScreen(),
        '/favoriteCoin': (context) => FavoriteCoinsScreen(coins: []),
      },
    );
  }
}
