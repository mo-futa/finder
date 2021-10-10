class User {
  final String id;
  final String name;
  final String imageUrl;
  bool isSpotMaker;
  List<dynamic>? favorites;

  User({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.isSpotMaker,
    this.favorites,
  });
}
