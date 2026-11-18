import '../models/driver.dart';
import '../models/ride.dart';
import '../models/service_class.dart';

/// Everything the app needs from the backend. The UI only talks to this
/// interface, so the demo implementation can be swapped for the real API
/// without touching any screen.
abstract interface class RideRepository {
  /// Asks for a login code. In the first release the dispatcher sees the
  /// code in the admin panel and reads it to the customer by phone;
  /// SMS delivery can be added later behind the same call.
  Future<void> requestCode(String phone);

  /// Returns an API token when the code is right.
  Future<String> verifyCode(String phone, String code);

  /// Online drivers who can take an order of [serviceClass].
  Future<List<Driver>> nearbyDrivers(ServiceClass serviceClass);

  Future<Ride> createRide({
    required ServiceClass serviceClass,
    required String pickup,
    required String dropoff,
    required double distanceKm,
  });

  /// Live updates for one ride: status, driver and arrival time.
  Stream<Ride> watchRide(String rideId);

  Future<void> cancelRide(String rideId);
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
