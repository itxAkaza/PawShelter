

class AppUrl {

  //  Base url
  static const String apiKey = "live_gn0kXmJEec05i9yPPj1inrB8SUhfALpXqryieVukn0pJrkN9eJUfuvHfY7VufsFv";
  static const String catBase = "https://api.thecatapi.com/v1";
  static const String dogBase = "https://api.thedogapi.com/v1";

  // For Cats
  static String catListUrl = '$catBase/images/search?limit=10&has_breeds=1&api_key=$apiKey';

  // For Dogs
  static String dogListUrl = '$dogBase/breeds?limit=10&page=0&api_key=$apiKey';

  // ---  Search URLs  ---

  // Search by Text
  static String searchCat(String query) => '$catBase/breeds/search?q=$query&api_key=$apiKey';
  static String searchDog(String query) => '$dogBase/breeds/search?q=$query&api_key=$apiKey';

  // Get Images by Breed ID (Step 2 of search)
  static String catImagesByBreedId(String breedId) => '$catBase/images/search?limit=10&breed_ids=$breedId&has_breeds=1&api_key=$apiKey';
  static String dogImagesByBreedId(String breedId) => '$dogBase/images/search?limit=10&breed_ids=$breedId&has_breeds=1&api_key=$apiKey';

}