class Place {
  String address;
  String name;
  String type;

  LatLon position;

  //All out of 5
  double socialDistancingScore;
  double cleanlinessScore;
  double staffFriendlinessScore;

  int ratingCount;

  //Other ratings ...

  Place(String address, String type, LatLon pos) {
    this.address = address;
    this.type = type;
    this.position = pos;
  }
}

class LatLon {
  double lat, lon;

  LatLon(double _lat, double _lon) {
    this.lat = _lat;
    this.lon = _lon;
  }
}
