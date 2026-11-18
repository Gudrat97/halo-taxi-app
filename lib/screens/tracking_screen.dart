import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../models/ride.dart';
import '../state/booking_controller.dart';
import '../theme.dart';
import '../widgets/city_map.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key, required this.controller});

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    final ride = controller.ride!;
    final driver = ride.driver;

    return Scaffold(
      appBar: AppBar(title: Text(ride.status.label, style: const TextStyle(fontWeight: FontWeight.w800))),
      body: Column(
        children: [
          Expanded(
            child: CityMap(
              drivers: driver != null ? [driver] : controller.drivers,
              highlight: driver,
            ),
          ),
          Material(
            color: haloPaper,
            elevation: 12,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (ride.status == RideStatus.searching)
                      const _Searching()
                    else if (driver != null && ride.status.isActive)
                      _DriverCard(driver: driver, ride: ride),
                    if (!ride.status.isActive) _Summary(ride: ride),
                    const SizedBox(height: 14),
                    _TripLine(ride: ride),
                    const SizedBox(height: 16),
                    if (ride.status.canCancel)
                      OutlinedButton(
                        onPressed: controller.busy ? null : controller.cancel,
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                        child: const Text('Cancel ride'),
                      )
                    else if (!ride.status.isActive)
                      FilledButton(onPressed: controller.finish, child: const Text('Book another ride')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Searching extends StatelessWidget {
  const _Searching();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 3)),
        SizedBox(width: 14),
        Expanded(child: Text('Sending your order to the nearest drivers…', style: TextStyle(fontSize: 16))),
      ],
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driver, required this.ride});

  final Driver driver;
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: haloYellow,
          child: Text(driver.name[0], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: haloInk)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${driver.name}  ★ ${driver.rating.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              Text(driver.car),
              Text(driver.phone, style: const TextStyle(color: Color(0xFF6B655A))),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(border: Border.all(color: haloInk, width: 2), borderRadius: BorderRadius.circular(6), color: Colors.white),
              child: Text(driver.plate, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
            const SizedBox(height: 6),
            if (ride.etaMinutes != null && ride.status == RideStatus.accepted)
              Text('${ride.etaMinutes} min away', style: const TextStyle(fontWeight: FontWeight.w600, color: haloGreen)),
          ],
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    final done = ride.status == RideStatus.completed;
    return Row(
      children: [
        Icon(done ? Icons.check_circle : Icons.cancel, color: done ? haloGreen : const Color(0xFF9A1B1B), size: 34),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            done ? 'You arrived. Please pay ${ride.fare} TMT in cash.' : 'Your ride was cancelled. You were not charged.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _TripLine extends StatelessWidget {
  const _TripLine({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD9D3C2))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride.pickup, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('to ${ride.dropoff}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6B655A))),
                ],
              ),
            ),
            Text('${ride.fare} TMT', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
