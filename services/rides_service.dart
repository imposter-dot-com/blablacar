import '../data/dummy_data.dart';
import '../models/ride/locations.dart';
import '../models/ride/ride.dart';

class RidesService {
  static List<Ride> availableRides = fakeRides; // TODO for now fake data

  //
  //  filter the rides starting from given departure location
  //
  static List<Ride> filterByDeparture(Location departure) {
    return availableRides.where((ride) => ride.departureLocation == departure).toList(); //filter the rides that have the departure location
  }

  //
  //  filter the rides starting for the given requested seat number
  //
  static List<Ride> filterBySeatRequested(int requestedSeat) {
    return availableRides.where((ride) => ride.availableSeats >= requestedSeat).toList(); //filter the rides that have the same number of available seats of requested seats or more
  }

  //
  //  filter the rides   with several optional criteria (flexible filter options)
  //
  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    return availableRides.where((ride) {
      if(departure != null && ride.departureLocation != departure){
        return false;
      } 
      
      if(seatRequested != null && ride.availableSeats < seatRequested){
        return false;
      }

      return true;
    }).toList();
  }
}