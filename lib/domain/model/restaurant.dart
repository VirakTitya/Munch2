class Restaurant {
  final String id;
  final String name;
  final String logoUrl;
  final String location;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.location,
    required this.rating, 
    required String deliveryTime,
  });
}
