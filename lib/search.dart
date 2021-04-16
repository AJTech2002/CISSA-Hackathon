import 'base.dart';

// begin mock functions

Future<List<Place>> fetchAllRestaurants() async{
  Place a= Place("5 queen st", "restaurant", LatLon(37.824611,144.943055));
  a.name = "mcdonalds";
  a.cleanlinessScore = 3;
  a.socialDistancingScore = 4;
  a.staffFriendlinessScore = 4;
  Place b = Place("2 swanston st", "restaurant", LatLon(37.814611,144.963055));
  b.name = "kfc";
  b.cleanlinessScore = 5;
  b.socialDistancingScore = 5;
  b.staffFriendlinessScore = 1;
  Place c = Place("253 swanston st", "casino", LatLon(37.813555,144.963955));
  c.name = "crown";
  c.cleanlinessScore = 5;
  c.socialDistancingScore = 4;
  c.staffFriendlinessScore = 5;
  return [
    a,
    b,
    c
  ];
}

LatLon getPos(){
  return LatLon(37.813611,144.963055);
}

// end mock functions


// Search function
// Return a list of Place that matches the search query, sorted by relevance 
// to the query, distance to user and health rating. If query is empty, then 
// return all places that are nearby and have a certain minimum health 
// rating.
// param: query:String represent the search query that the result must match
// return: List<Place> the sorted list of relevant places
Future<List<Place>> search(String query) async
{
  query = query.toLowerCase();
  // split query base on spaces to find keyword
  var querySplit = query.split(" ");
  // retrieve places from database
  var places = await fetchAllRestaurants();
  // 
  var currentPos=getPos();


  // Returns a score for how relevant a place is, higher is better. If the 
  // place's name contains a keyword then it receives a score of 1, if its 
  // address contains a keyword then it receives a score of 0.5, if its type
  // contains a keyword then it receives a score of 2. All scores are 
  // additive.
  double relevanceScore(Place place)
  {
    return querySplit.fold<double>(0.0, (previousValue, element) => previousValue+(place.name.contains(element)?1:0) + (place.address.contains(element)?0.5:0) + ((place.type.contains(element))?2:0));
  }

  // Calculate the penalty score for a place, lower is better. Calculated
  // by the distance plus the average health score. A place that averages 
  // 5 stars and is 1km away gets the same score as one that averages 4 
  // stars and is immediately nearby.
  double penaltyScore(Place place)
  {
    var dist = place.position.distance(currentPos); 
    return dist+(15-place.cleanlinessScore-place.socialDistancingScore-place.staffFriendlinessScore)/3;
  }

  // Check for search query
  if(query.isNotEmpty)
  {
    // Remove irrelevant places and places with very long distance or very
    // low health rating. Keep only places with less penalty score than 5.
    places.removeWhere((element) => relevanceScore(element)==0 || penaltyScore(element)>=5);
    // Sort list by relevance minus penalty score, from highest to lowest.
    places.sort((a, b) => (((relevanceScore(b)-penaltyScore(b))-(relevanceScore(a)-penaltyScore(a)))*10).round());
    return places;
  }
  else
  {
    // Remove places with long distance or low health rating. Keep only
    // places with penalty score less than 2.5.
    places.removeWhere((element) => penaltyScore(element)>=2.5);
    // Sort list by penalty score, from lowest to highest.
    places.sort((a,b) => ((penaltyScore(a)-penaltyScore(b))*10).round());
    return places;
  }
}

