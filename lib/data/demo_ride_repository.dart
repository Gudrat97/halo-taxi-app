import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import '../models/driver.dart';
import '../models/ride.dart';
import '../models/service_class.dart';
import 'ride_repository.dart';

/// Works without a server so the app can be tried right away.
/// Any 4-digit code signs in; rides move through every status on a timer.
class DemoRideRepository implements RideRepository {
  DemoRideRepository({math.Random? random}) : _random = random ?? math.Random();

  final math.Random _random;
  final Map<String, StreamController<Ride>> _rides = {};
  final Map<String, Timer> _timers = {};

  static const _drivers = [
    Driver(id: '1', name: 'Merdan A.', phone: '+993 65 123456', carModel: 'Toyota Camry', carYear: 2021, carColor: 'White', plate: 'AG 4521', rating: 4.9, serviceClass: ServiceClass.comfort, position: Offset(.32, .38)),
    Driver(id: '2', name: 'Bahar S.', phone: '+993 61 234567', carModel: 'Hyundai Elantra', carYear: 2019, carColor: 'Silver', plate: 'AG 7310', rating: 4.8, serviceClass: ServiceClass.economy, position: Offset(.62, .30)),
    Driver(id: '3', name: 'Dowlet K.', phone: '+993 62 345678', carModel: 'Lexus ES 350', carYear: 2023, carColor: 'Black', plate: 'AG 0007', rating: 5.0, serviceClass: ServiceClass.vip, position: Offset(.74, .58)),
    Driver(id: '4', name: 'Aman R.', phone: '+993 63 456789', carModel: 'Toyota Sienna', carYear: 2020, carColor: 'Grey', plate: 'AG 2288', rating: 4.7, serviceClass: ServiceClass.minivan, position: Offset(.22, .64)),
    Driver(id: '5', name: 'Serdar M.', phone: '+993 64 567890', carModel: 'Kia Rio', carYear: 2018, carColor: 'Blue', plate: 'AG 5174', rating: 4.6, serviceClass: ServiceClass.economy, position: Offset(.48, .72)),
    Driver(id: '6', name: 'Jeren B.', phone: '+993 65 678901', carModel: 'Chevrolet Damas', carYear: 2022, carColor: 'White', plate: 'AG 9031', rating: 4.8, serviceClass: ServiceClass.courier, position: Offset(.56, .46)),
  ];

  Future<void> _latency() => Future.delayed(Duration(milliseconds: 400 + _random.nextInt(400)));

  @override
  Future<void> requestCode(String phone) => _latency();

  @override
  Future<String> verifyCode(String phone, String code) async {
    await _latency();
    if (!RegExp(r'^\d{4}$').hasMatch(code)) {
      throw const AuthException('The code has 4 digits. Check it and try again.');
    }
    return 'demo-token-${phone.hashCode}';
  }

  @override
  Future<List<Driver>> nearbyDrivers(ServiceClass serviceClass) async {
    await _latency();
    return _drivers.where((d) => serviceClass.servedBy.contains(d.serviceClass)).toList();
  }

  @override
  Future<Ride> createRide({
    required ServiceClass serviceClass,
    required String pickup,
    required String dropoff,
    required double distanceKm,
  }) async {
    await _latency();
    final ride = Ride(
      id: 'R${DateTime.now().millisecondsSinceEpoch}',
      serviceClass: serviceClass,
      pickup: pickup,
      dropoff: dropoff,
      distanceKm: distanceKm,
      fare: serviceClass.fareFor(distanceKm),
      status: RideStatus.searching,
    );

    final controller = StreamController<Ride>.broadcast();
    _rides[ride.id] = controller;
    _simulate(ride, controller);
    return ride;
  }

  /// searching → accepted → (driver drives up) → arrived → onTrip → completed
  void _simulate(Ride initial, StreamController<Ride> out) {
    var ride = initial;
    var tick = 0;
    final candidates = _drivers.where((d) => initial.serviceClass.servedBy.contains(d.serviceClass)).toList();
    const pickupPoint = Offset(.5, .5);

    _timers[ride.id] = Timer.periodic(const Duration(seconds: 2), (timer) {
      tick++;
      if (ride.status == RideStatus.searching && tick >= 2) {
        ride = ride.copyWith(status: RideStatus.accepted, driver: candidates.first, etaMinutes: 4);
      } else if (ride.status == RideStatus.accepted) {
        final d = ride.driver!;
        final next = Offset.lerp(d.position, pickupPoint, .35)!;
        final eta = math.max(1, (ride.etaMinutes ?? 4) - 1);
        ride = (next - pickupPoint).distance < .04
            ? ride.copyWith(status: RideStatus.arrived, driver: d.movedTo(pickupPoint), etaMinutes: 0)
            : ride.copyWith(driver: d.movedTo(next), etaMinutes: eta);
      } else if (ride.status == RideStatus.arrived && tick % 3 == 0) {
        ride = ride.copyWith(status: RideStatus.onTrip);
      } else if (ride.status == RideStatus.onTrip && tick % 4 == 0) {
        ride = ride.copyWith(status: RideStatus.completed);
        timer.cancel();
      }
      if (!out.isClosed) out.add(ride);
    });
  }

  @override
  Stream<Ride> watchRide(String rideId) => _rides[rideId]?.stream ?? const Stream.empty();

  @override
  Future<void> cancelRide(String rideId) async {
    await _latency();
    _timers.remove(rideId)?.cancel();
    final controller = _rides.remove(rideId);
    await controller?.close();
  }
}
