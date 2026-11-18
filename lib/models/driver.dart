import 'dart:ui';

import 'service_class.dart';

class Driver {
  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.carModel,
    required this.carYear,
    required this.carColor,
    required this.plate,
    required this.rating,
    required this.serviceClass,
    required this.position,
  });

  final String id;
  final String name;
  final String phone;
  final String carModel;
  final int carYear;
  final String carColor;
  final String plate;
  final double rating;
  final ServiceClass serviceClass;

  /// Position on the demo map, from 0 to 1 on both axes.
  final Offset position;

  String get car => '$carColor $carModel, $carYear';

  Driver movedTo(Offset next) => Driver(
        id: id,
        name: name,
        phone: phone,
        carModel: carModel,
        carYear: carYear,
        carColor: carColor,
        plate: plate,
        rating: rating,
        serviceClass: serviceClass,
        position: next,
      );

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['id'].toString(),
        name: json['name'] as String,
        phone: json['phone'] as String,
        carModel: json['car_model'] as String,
        carYear: json['car_year'] as int,
        carColor: json['car_color'] as String,
        plate: json['plate'] as String,
        rating: (json['rating'] as num).toDouble(),
        serviceClass: ServiceClass.values.byName(json['class'] as String),
        position: Offset(
          (json['x'] as num).toDouble(),
          (json['y'] as num).toDouble(),
        ),
      );
}
