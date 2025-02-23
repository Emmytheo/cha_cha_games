import 'dart:math';

class GameServer {
  String serverCountry;
  double entryFee;
  double price;

  GameServer({required this.serverCountry, required this.entryFee, required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameServer &&
          runtimeType == other.runtimeType &&
          serverCountry == other.serverCountry &&
          entryFee == other.entryFee &&
          price == other.price;

  @override
  int get hashCode => serverCountry.hashCode ^ entryFee.hashCode ^ price.hashCode;
}

// List<GameServer> generateRandomGameServers(int count, List<GameServer>? prev_servers) {
//   final random = Random();
//   final countries = ['USA', 'Canada', 'Germany', 'Japan', 'Australia', 'UK', 'France', 'Brazil', 'India', 'China'];

//   Set<GameServer> servers = prev_servers != null ? prev_servers.toSet() : <GameServer>{};

//   while (servers.length < count) {
//     String country = countries[random.nextInt(countries.length)];
//     double entryFee = random.nextDouble() * 100; // Random entry fee between 0 and 100
//     double price = random.nextDouble() * 1000; // Random price between 0 and 1000

//     servers.add(GameServer(serverCountry: country, entryFee: entryFee, price: price));
//   }

//   return servers.toList();
// }

List<GameServer> generateRandomGameServers(int count, List<GameServer>? prev_servers) {
  final random = Random();
  final cities = [
    // North America
    'New York', 'Toronto', 'Los Angeles', 'Chicago', 'Vancouver', 'Miami',
    // Europe
    'London', 'Paris', 'Berlin', 'Amsterdam', 'Madrid', 'Rome', 'Stockholm',
    // Asia
    'Tokyo', 'Mumbai', 'Singapore', 'Shanghai', 'Seoul', 'Dubai', 'Hong Kong',
    'Bangkok', 'Jakarta', 'Istanbul',
    // Africa
    'Lagos', 'Cairo', 'Nairobi', 'Cape Town', 'Accra', 'Johannesburg',
    'Addis Ababa', 'Casablanca', 'Kigali', 'Dakar', 'Kampala', 'Abuja',
    'Port Louis', 'Lusaka', 'Gaborone', 'Windhoek', 'Tunis',
    // Oceania
    'Sydney', 'Melbourne', 'Auckland'
  ];

  Set<GameServer> servers = prev_servers != null ? prev_servers.toSet() : <GameServer>{};

  while (servers.length < count) {
    String city = cities[random.nextInt(cities.length)];
    double entryFee = random.nextDouble() * 100; // Random entry fee between 0 and 100
    double price = random.nextDouble() * 1000; // Random price between 0 and 1000

    servers.add(GameServer(serverCountry: city, entryFee: entryFee, price: price));
  }

  return servers.toList();
}

