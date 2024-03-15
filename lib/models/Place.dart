class Place {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final String lat;
  final String lon;
  final String classType;
  final String type;
  final int placeRank;
  final double importance;
  final String addressType;
  final String name;
  final String displayName;
  final List<String> boundingBox;

  Place({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.classType,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addressType,
    required this.name,
    required this.displayName,
    required this.boundingBox,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      lat: json['lat'],
      lon: json['lon'],
      classType: json['class'],
      type: json['type'],
      placeRank: json['place_rank'],
      importance: json['importance'].toDouble(),
      addressType: json['addresstype'],
      name: json['name'],
      displayName: json['display_name'],
      boundingBox: List<String>.from(json['boundingbox']),
    );
  }
}