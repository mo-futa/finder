class Spot {
  String? id;
  double? rating;
  int? numberOfRatings;
  List<dynamic> imageUrls;
  String name;
  String category;
  MyPosition myPosition;


  Spot({
    this.id,
    this.rating,
    this.numberOfRatings,
    required this.category,
    required this.imageUrls,
    required this.myPosition,
    required this.name,
  });
}

class MyPosition {
  double latitude;
  double longitube;
  MyPosition({required this.latitude, required this.longitube});
}
