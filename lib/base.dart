import 'dart:math';

class Place {

  String address;
  String name;
  String type;

  LatLon position;
  
  //All out of 5
  double socialDistancingScore;
  double cleanlinessScore;
  double staffFriendlinessScore;

  //Other ratings ...
  

  Place (String address, String type, LatLon pos)
  {
    this.address = address;
    this.type = type;
    this.position = pos;
  }
  
}

class LatLon {
  double lat,lon;

  LatLon (double _lat, double _lon)
  {
    this.lat = _lat;
    this.lon = _lon;
  }

  double distance(LatLon other)
  {
    return pow(pow(this.lat-other.lat,2)+pow(this.lon-other.lon, 2),0.5);
  }
}
