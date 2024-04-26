import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewCoinScreen extends StatefulWidget {
  @override
  _ViewCoinScreenState createState() => _ViewCoinScreenState();
}

class _ViewCoinScreenState extends State<ViewCoinScreen> {
  List<Coin>? coins;

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
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.pushNamed(context, '/filterCoin');
            },
          ),
        ],
      ),
      body: coins != null
          ? ListView.builder(
              itemCount: coins!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(coins![index].name),
                  subtitle: Text(coins![index].symbol),
                  trailing: Text('\$${coins![index].price.toStringAsFixed(2)}'),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
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
