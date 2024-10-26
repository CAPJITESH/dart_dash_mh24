class WatchlistItem {
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double change;
  final double changePercentage;
  final String id;
  final String high24h;
  final String low24h;

  WatchlistItem({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.id,
    required this.high24h,
    required this.low24h,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'imageUrl': imageUrl,
      'price': price,
      'change': change,
      'changePercentage': changePercentage,
      'id': id,
      'high_24h': high24h,
      'low_24h': low24h,
    };
  }
}
