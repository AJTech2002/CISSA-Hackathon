import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Place> _listOfPlaces;

Place firebaseStore(Place newDetails) {
  CollectionReference places = FirebaseFirestore.instance.collection('Places');
  places.doc(newDetails.address).set(_placeToMap(newDetails));

  if (_listOfPlaces != null)
  for (int i = 0; i < _listOfPlaces.length; i++) {
    if (_listOfPlaces[i].address == newDetails.address)
    {
      _listOfPlaces[i] = newDetails.copy();
      return _listOfPlaces[i];
    }
  }

  return null;

}

Future<Place> getByAddress (String address) async
{
  List<Place> places = new List<Place>();
  if (_listOfPlaces != null)
  {
    places = _listOfPlaces;
  }
  else {
    places = await fetchAll();

  }

  for (int i = 0; i < places.length; i++)
  {
    if (places[i].address == address) return places[i];
  }

  return null;
}

Future<List<Place>> fetchAll() async
{ 
  if(_listOfPlaces!=null) return List.from(_listOfPlaces);
  _listOfPlaces = [];
  CollectionReference places = FirebaseFirestore.instance.collection('Places');
  var collectionSnapshot = await places.get();
  collectionSnapshot.docs.forEach((element) {  _listOfPlaces.add(_snapshotToPlace(element));});

  print ("Firebase:" + _listOfPlaces.length.toString());

  return List.from(_listOfPlaces);
}

Future<List<Place>> fetchByType(String type) async
{
  var places = await fetchAll();
  places.removeWhere((element) => !element.type.contains(type));
  return places;
}

Map<String, dynamic> _placeToMap(Place place) {
  return {
    'name': place.name,
    'address': place.address,
    'type': place.type,
    'position_lon': place.position.lon,
    'position_lat': place.position.lat,
    'rating_count': place.ratingCount,
    'social_distancing_score': place.socialDistancingScore,
    'cleanliness_score': place.cleanlinessScore,
    'staff_friendliness_score': place.staffFriendlinessScore,
  };
}

Place _snapshotToPlace(DocumentSnapshot snapshot) {
  Place place = Place(snapshot['address'], snapshot['type'],
  LatLon((snapshot['position_lat']).toDouble(),(snapshot['position_lon']).toDouble()));
  place.name = snapshot['name'];
  place.ratingCount = snapshot['rating_count'];
  place.socialDistancingScore = (snapshot['social_distancing_score']).toDouble();
  place.cleanlinessScore = (snapshot['cleanliness_score']).toDouble();
  place.staffFriendlinessScore = (snapshot['staff_friendliness_score']).toDouble();
  return place;
}


// Rate a place and store rating in the database. If the place does not exist then
// return false, otherwise return true.
Future<bool> rate(String address, double socialDistancingScore, double cleanlinessScore, double staffFriendlinessScore) async
{
  if(!knownLocation(address)) return false;
  Place place = (await fetchAll()).firstWhere((element) => element.address==address);
  int count = place.ratingCount;
  place.socialDistancingScore = (count * place.socialDistancingScore + socialDistancingScore) / (count + 1);
  place.cleanlinessScore = (count * place.cleanlinessScore + cleanlinessScore) / (count + 1);
  place.staffFriendlinessScore = (count * place.staffFriendlinessScore + staffFriendlinessScore) / (count + 1);
  place.ratingCount++;
  firebaseStore(place);
  FirebaseFirestore.instance.collection("Ratings").add({
    'address': address, 
    'socialDistancingScore': socialDistancingScore,
    'cleanlinessScore': cleanlinessScore,
    'staffFriendlinessScore': staffFriendlinessScore
  });
  return true;
}

bool knownLocation(String address)
{
  if(_listOfPlaces == null) fetchAll();
  return _listOfPlaces.indexWhere((element) => element.address==address) > -1;
}

void storeNew(Place place)
{
  if(_listOfPlaces==null) fetchAll();
  _listOfPlaces.add(place);
  firebaseStore(place);
}