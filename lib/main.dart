import 'package:flutter/material.dart';

import 'data/demo_ride_repository.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tracking_screen.dart';
import 'state/booking_controller.dart';
import 'theme.dart';

void main() {
  // Replace DemoRideRepository with an API-backed implementation for production.
  final controller = BookingController(DemoRideRepository());
  runApp(HaloTaxiApp(controller: controller));
}

class HaloTaxiApp extends StatelessWidget {
  const HaloTaxiApp({super.key, required this.controller});

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halo Taxi',
      debugShowCheckedModeBanner: false,
      theme: haloTheme(),
      home: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (!controller.signedIn) return LoginScreen(controller: controller);
          if (controller.ride != null) return TrackingScreen(controller: controller);
          return HomeScreen(controller: controller);
        },
      ),
    );
  }
}
