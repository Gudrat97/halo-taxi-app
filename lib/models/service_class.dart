import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Car classes offered by the taxi park. Each class has its own tariff.
/// Higher classes can also take orders from lower ones, so an Economy
/// order may be served by a Comfort car when no Economy car is free.
enum ServiceClass {
  economy(
    label: 'Economy',
    description: 'Everyday rides, up to 4 people',
    icon: Icons.directions_car_outlined,
    baseFare: 8,
    perKm: 1.6,
    minFare: 12,
  ),
  comfort(
    label: 'Comfort',
    description: 'Newer cars, more legroom',
    icon: Icons.directions_car,
    baseFare: 12,
    perKm: 2.2,
    minFare: 18,
  ),
  vip(
    label: 'VIP',
    description: 'Business class sedans',
    icon: Icons.star_rounded,
    baseFare: 25,
    perKm: 3.5,
    minFare: 35,
  ),
  minivan(
    label: 'Minivan',
    description: 'Up to 7 people with luggage',
    icon: Icons.airport_shuttle,
    baseFare: 18,
    perKm: 2.8,
    minFare: 25,
  ),
  courier(
    label: 'Courier',
    description: 'Send a parcel across the city',
    icon: Icons.local_shipping_outlined,
    baseFare: 10,
    perKm: 1.4,
    minFare: 12,
  );

  const ServiceClass({
    required this.label,
    required this.description,
    required this.icon,
    required this.baseFare,
    required this.perKm,
    required this.minFare,
  });

  final String label;
  final String description;
  final IconData icon;

  /// Prices are in Turkmen manat (TMT).
  final double baseFare;
  final double perKm;
  final double minFare;

  /// Fixed fare shown before the order is placed, rounded to whole manat.
  int fareFor(double distanceKm) {
    final price = baseFare + perKm * math.max(0, distanceKm);
    return math.max(minFare, price).round();
  }

  /// Classes whose drivers may take an order of this class.
  List<ServiceClass> get servedBy => switch (this) {
        ServiceClass.economy => const [
            ServiceClass.economy,
            ServiceClass.comfort,
            ServiceClass.vip,
          ],
        ServiceClass.comfort => const [ServiceClass.comfort, ServiceClass.vip],
        ServiceClass.vip => const [ServiceClass.vip],
        ServiceClass.minivan => const [ServiceClass.minivan],
        ServiceClass.courier => const [
            ServiceClass.courier,
            ServiceClass.economy,
          ],
      };
}
