import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        '/': (context) => ViewCoinScreen(), // Alterado para exibir ViewCoinScreen diretamente
      },
    );
  }
}

class ViewCoinScreen extends StatefulWidget {
  @override
  _ViewCoinScreenState createState() => _ViewCoinScreenState();
}

class _ViewCoinScreenState extends State<ViewCoinScreen> {
  late List<Coin> coins; // Alterado para ser inicializado mais tarde

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    final response = await http.get(Uri.parse('https://economia.awesomeapi.com.br/all'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      List<Coin> fetchedCoins = [];

      data.forEach((key, value) {
        Coin coin = Coin(
          name: value['name'],
          symbol: value['code'],
          price: double.parse(value['high']),
        );
        fetchedCoins.add(coin);
      });

      setState(() {
        coins = fetchedCoins;
      });
    } else {
      throw Exception('Failed to load coins');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Moedas'),
      ),
      body: coins != null // Verifica se a lista de moedas já foi carregada
          ? ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(coins[index].name),
                  subtitle: Text(coins[index].symbol),
                  trailing: Text('\$${coins[index].price.toStringAsFixed(2)}'),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(), // Exibe indicador de carregamento enquanto os dados são carregados
            ),
    );
  }
}

class Coin {
  final String name;
  final String symbol;
  final double price;

  Coin({required this.name, required this.symbol, required this.price});
}
