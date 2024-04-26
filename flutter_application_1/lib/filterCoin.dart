import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FilterCoinScreen extends StatefulWidget {
  @override
  _FilterCoinScreenState createState() => _FilterCoinScreenState();
}

class _FilterCoinScreenState extends State<FilterCoinScreen> {
  List<Coin>? coins;
  late List<Coin> filteredCoins;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCoins();
    filteredCoins = [];
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
        filteredCoins = List.from(coins!);
      });
    } else {
      throw Exception('Failed to load coins');
    }
  }

  void filterCoins(String searchText) {
    setState(() {
      filteredCoins = coins!.where((coin) {
        return coin.name.toLowerCase().contains(searchText.toLowerCase()) ||
               coin.symbol.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro de Moedas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar moedas',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterCoins(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCoins.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredCoins[index].name),
                  subtitle: Text(filteredCoins[index].symbol),
                  trailing: Text('\$${filteredCoins[index].price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
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
