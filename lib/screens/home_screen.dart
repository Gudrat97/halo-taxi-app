import 'package:flutter/material.dart';

import '../models/service_class.dart';
import '../state/booking_controller.dart';
import '../theme.dart';
import '../widgets/city_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CityMap(drivers: c.drivers)),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: haloYellow, borderRadius: BorderRadius.circular(999), border: Border.all(color: haloInk, width: 2)),
              child: Text('${c.drivers.length} cars nearby', style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _OrderSheet(controller: c),
          ),
        ],
      ),
    );
  }
}

class _OrderSheet extends StatelessWidget {
  const _OrderSheet({required this.controller});

  final BookingController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Material(
      color: haloPaper,
      elevation: 12,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: c.setPickup,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.my_location), hintText: 'Where are you?'),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: c.setDropoff,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.flag_outlined), hintText: 'Where to?'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 112,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ServiceClass.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final s = ServiceClass.values[i];
                    return _ClassCard(
                      serviceClass: s,
                      fare: s.fareFor(c.distanceKm),
                      selected: s == c.selectedClass,
                      onTap: () => c.selectClass(s),
                    );
                  },
                ),
              ),
              if (c.error != null) ...[
                const SizedBox(height: 10),
                Text(c.error!, style: const TextStyle(color: Color(0xFF9A1B1B))),
              ],
              const SizedBox(height: 14),
              FilledButton(
                onPressed: c.canOrder ? c.order : null,
                child: Text('Order ${c.selectedClass.label} for ${c.fare} TMT'),
              ),
              const SizedBox(height: 6),
              const Text('Fixed price, paid in cash to the driver', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B655A))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.serviceClass, required this.fare, required this.selected, required this.onTap});

  final ServiceClass serviceClass;
  final int fare;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? haloYellow : haloInk;

    return Semantics(
      selected: selected,
      button: true,
      label: '${serviceClass.label}, $fare manat',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 112,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? haloInk : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: haloInk, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(serviceClass.icon, color: fg),
              const Spacer(),
              Text(serviceClass.label, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
              Text('$fare TMT', style: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
