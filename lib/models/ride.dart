import 'driver.dart';
import 'service_class.dart';

enum RideStatus {
  searching('Looking for a car'),
  accepted('Driver is on the way'),
  arrived('Your car is outside'),
  onTrip('On the way'),
  completed('Ride finished'),
  cancelled('Ride cancelled');

  const RideStatus(this.label);
  final String label;

  bool get isActive => this != completed && this != cancelled;

  /// The customer may cancel until the trip starts.
  bool get canCancel => this == searching || this == accepted;
}

class Ride {
  const Ride({
    required this.id,
    required this.serviceClass,
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
    required this.fare,
    required this.status,
    this.driver,
    this.etaMinutes,
  });

  final String id;
  final ServiceClass serviceClass;
  final String pickup;
  final String dropoff;
  final double distanceKm;

  /// Fixed fare in manat, paid in cash to the driver.
  final int fare;
  final RideStatus status;
  final Driver? driver;
  final int? etaMinutes;

  Ride copyWith({RideStatus? status, Driver? driver, int? etaMinutes}) => Ride(
        id: id,
        serviceClass: serviceClass,
        pickup: pickup,
        dropoff: dropoff,
        distanceKm: distanceKm,
        fare: fare,
        status: status ?? this.status,
        driver: driver ?? this.driver,
        etaMinutes: etaMinutes ?? this.etaMinutes,
      );
}
