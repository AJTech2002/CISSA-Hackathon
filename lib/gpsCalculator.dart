import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'base.dart';

// getCurrentLocation() is modified based on the usage example at https://pub.dev/packages/geolocator, published Apr 14, 2021

/// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the Future will return an error.
  Future<LatLon> getCurrentLocation() async {

    print ("STARTED");

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

  print("FINDING??");
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    print ("FOUND");
    print (long);
    print (lat);
    return LatLon(lat, long);
  }

  Future<String> getAddress(LatLon position) async {
    final coordinates = new Coordinates(position.lat, position.lon);
    var addresseses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String address = addresseses.first.addressLine;
    return address;
  }

  double getDistance(LatLon a, LatLon b) {
    var firstLatitude = a.lat;
    var firstLongitude = a.lon;
    var secondLatitude = b.lat;
    var secondLongitude = b.lon;

    double distanceInMeters = Geolocator.distanceBetween(
        firstLatitude, firstLongitude, secondLatitude, secondLongitude);

    return distanceInMeters;
  }