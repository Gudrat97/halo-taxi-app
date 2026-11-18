import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/ride_repository.dart';
import '../models/driver.dart';
import '../models/ride.dart';
import '../models/service_class.dart';

/// Holds the state of the whole booking flow and talks to the repository.
/// Screens listen to it and call its methods; they never call the API directly.
class BookingController extends ChangeNotifier {
  BookingController(this._repo);

  final RideRepository _repo;
  StreamSubscription<Ride>? _rideSub;

  String? phone;
  String? token;
  bool codeRequested = false;

  ServiceClass selectedClass = ServiceClass.economy;
  List<Driver> drivers = const [];
  String pickup = '';
  String dropoff = '';

  /// In the real app this comes from the routing service.
  double distanceKm = 6.4;

  Ride? ride;
  bool busy = false;
  String? error;

  bool get signedIn => token != null;
  int get fare => selectedClass.fareFor(distanceKm);
  bool get canOrder => pickup.trim().isNotEmpty && dropoff.trim().isNotEmpty && !busy;

  Future<void> requestCode(String value) => _run(() async {
        phone = value.trim();
        await _repo.requestCode(phone!);
        codeRequested = true;
      });

  Future<void> verifyCode(String code) => _run(() async {
        token = await _repo.verifyCode(phone!, code.trim());
        await _loadDrivers();
      });

  Future<void> selectClass(ServiceClass value) async {
    if (value == selectedClass) return;
    selectedClass = value;
    notifyListeners();
    await _run(_loadDrivers);
  }

  void setPickup(String value) {
    pickup = value;
    notifyListeners();
  }

  void setDropoff(String value) {
    dropoff = value;
    notifyListeners();
  }

  Future<void> order() => _run(() async {
        final created = await _repo.createRide(
          serviceClass: selectedClass,
          pickup: pickup.trim(),
          dropoff: dropoff.trim(),
          distanceKm: distanceKm,
        );
        ride = created;
        await _rideSub?.cancel();
        _rideSub = _repo.watchRide(created.id).listen((update) {
          ride = update;
          notifyListeners();
        });
      });

  Future<void> cancel() => _run(() async {
        final current = ride;
        if (current == null || !current.status.canCancel) return;
        await _rideSub?.cancel();
        await _repo.cancelRide(current.id);
        ride = current.copyWith(status: RideStatus.cancelled);
      });

  void finish() {
    _rideSub?.cancel();
    ride = null;
    notifyListeners();
  }

  Future<void> _loadDrivers() async {
    drivers = await _repo.nearbyDrivers(selectedClass);
  }

  Future<void> _run(Future<void> Function() action) async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } on AuthException catch (e) {
      error = e.message;
    } catch (_) {
      error = 'Something went wrong. Check your connection and try again.';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _rideSub?.cancel();
    super.dispose();
  }
}
