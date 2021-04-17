import 'dart:math';

class Place {

  String address;
  String name;
  String type;

  LatLon position;
  
  int ratingCount = 0;
  //All out of 5
  double socialDistancingScore = 0.0;
  double cleanlinessScore= 0.0;
  double staffFriendlinessScore= 0.0;

  //Other ratings ...
  
  Place copy ()
  {
    Place a = new Place(address, type, position);
    a.name = name;
    a.address = address;
    a.type = type;
    a.position = new LatLon(position.lat,position.lon);
    a.ratingCount = ratingCount;
    a.socialDistancingScore = socialDistancingScore;
    a.cleanlinessScore = cleanlinessScore;
    a.staffFriendlinessScore = staffFriendlinessScore;
    return a;
  }

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
}
