class Restaurant {
  final String id;
  final String name;
  final String logoUrl;
  final String? location;
  final String? deliveryTime;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.location,
    this.deliveryTime,
    required this.rating,
  });
}
