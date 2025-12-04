class LocationHistory {
  int? id;
  double latitude;
  double longitude;
  String date;
  String? address;

  LocationHistory({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'address': address,
    };
  }
  factory LocationHistory.fromMap(Map<String, dynamic> map) {
    return LocationHistory(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      date: map['date'],
      address: map['address'],
    );
  }
}