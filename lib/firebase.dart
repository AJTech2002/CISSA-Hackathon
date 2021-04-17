import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Place> _listOfPlaces;

firebaseStore(Place newDetails) {
  // THis function works
  CollectionReference places = FirebaseFirestore.instance.collection('Places');
  places.doc(newDetails.address).set(_placeToMap(newDetails));
}

fetchAll() async {
  //function is working
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Places');
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

fetchByType(String type) async {
  var places = await fetchAll();
  places.removeWhere(([element]) => element['type'] != type);
  print("*******************");
  print(places);
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
      LatLon(snapshot['position_lon'], snapshot['position_lat']));
  place.name = snapshot['name'];
  place.ratingCount = snapshot['rating_count'];
  place.socialDistancingScore = snapshot['social_distancing_score'];
  place.cleanlinessScore = snapshot['cleanliness_score'];
  place.staffFriendlinessScore = snapshot['staff_friendliness_score'];
  return place;
}
