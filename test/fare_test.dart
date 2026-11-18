import 'package:flutter_test/flutter_test.dart';
import 'package:halo_taxi/data/demo_ride_repository.dart';
import 'package:halo_taxi/data/ride_repository.dart';
import 'package:halo_taxi/models/ride.dart';
import 'package:halo_taxi/models/service_class.dart';

void main() {
  group('fares', () {
    test('short trips pay the minimum fare', () {
      expect(ServiceClass.economy.fareFor(0.5), 12);
      expect(ServiceClass.vip.fareFor(1), 35);
    });

    test('longer trips pay base plus distance', () {
      // 8 + 1.6 * 10 = 24
      expect(ServiceClass.economy.fareFor(10), 24);
    });

    test('higher classes can serve lower ones', () {
      expect(ServiceClass.economy.servedBy, contains(ServiceClass.comfort));
      expect(ServiceClass.vip.servedBy, isNot(contains(ServiceClass.economy)));
    });
  });

  group('ride status', () {
    test('a ride can be cancelled only before the trip starts', () {
      expect(RideStatus.searching.canCancel, isTrue);
      expect(RideStatus.accepted.canCancel, isTrue);
      expect(RideStatus.onTrip.canCancel, isFalse);
    });
  });

  group('demo repository', () {
    final repo = DemoRideRepository();

    test('rejects a code that is not 4 digits', () {
      expect(repo.verifyCode('+993 65 000000', '12'), throwsA(isA<AuthException>()));
    });

    test('creates a ride with the class fare', () async {
      final ride = await repo.createRide(
        serviceClass: ServiceClass.comfort,
        pickup: 'Bitarap Turkmenistan Avenue',
        dropoff: 'Airport',
        distanceKm: 12,
      );
      expect(ride.fare, ServiceClass.comfort.fareFor(12));
      expect(ride.status, RideStatus.searching);
      await repo.cancelRide(ride.id);
    });
  });
}
