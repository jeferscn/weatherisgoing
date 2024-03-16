
class Place {
  final double latitude;
  final double longitude;

  Place({
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}