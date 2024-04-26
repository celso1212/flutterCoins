import 'package:flutter/material.dart';

class Coin {
  final String name;
  final String symbol;
  final double price;
  bool isFavorite;

  Coin({
    required this.name,
    required this.symbol,
    required this.price,
    this.isFavorite = false,
  });
}

class FavoriteCoinsScreen extends StatefulWidget {
  final List<Coin> coins;

  FavoriteCoinsScreen({required this.coins});

  @override
  _FavoriteCoinsScreenState createState() => _FavoriteCoinsScreenState();
}

class _FavoriteCoinsScreenState extends State<FavoriteCoinsScreen> {
  late List<Coin> _favoriteCoins;

  @override
  void initState() {
    super.initState();
    _favoriteCoins =
        widget.coins.where((coin) => coin.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moedas Favoritadas'),
      ),
      body: _favoriteCoins.isNotEmpty
          ? ListView.builder(
              itemCount: _favoriteCoins.length,
              itemBuilder: (context, index) {
                Coin coin = _favoriteCoins[index];
                return ListTile(
                  title: Text(coin.name),
                  subtitle: Text(coin.symbol),
                  trailing: Text('\$${coin.price.toStringAsFixed(2)}'),
                );
              },
            )
          : Center(
              child: Text('Nenhuma moeda favoritada.'),
            ),
    );
  }
}
