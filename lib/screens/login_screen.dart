import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/booking_controller.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});

  final BookingController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController(text: '+993 ');
  final _code = TextEditingController();

  BookingController get c => widget.controller;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: haloYellow,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          children: [
            const Icon(Icons.local_taxi_rounded, size: 56, color: haloInk),
            const SizedBox(height: 24),
            Text(
              c.codeRequested ? 'Enter your code' : 'Sign in with your phone',
              style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: haloInk),
            ),
            const SizedBox(height: 8),
            Text(
              c.codeRequested
                  ? 'Our dispatcher will call ${c.phone} and tell you a 4-digit code.'
                  : 'We use your number so the driver can reach you.',
              style: text.bodyLarge?.copyWith(color: haloInk),
            ),
            const SizedBox(height: 32),
            if (!c.codeRequested)
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: const InputDecoration(labelText: 'Phone number'),
              )
            else
              TextField(
                controller: _code,
                keyboardType: TextInputType.number,
                maxLength: 4,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 28, letterSpacing: 12, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(labelText: 'Code', counterText: ''),
              ),
            if (c.error != null) ...[
              const SizedBox(height: 12),
              Text(c.error!, style: const TextStyle(color: Color(0xFF9A1B1B), fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: c.busy
                  ? null
                  : () => c.codeRequested ? c.verifyCode(_code.text) : c.requestCode(_phone.text),
              child: c.busy
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Text(c.codeRequested ? 'Sign in' : 'Get a code'),
            ),
          ],
        ),
      ),
    );
  }
}
