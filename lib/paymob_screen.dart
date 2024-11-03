import 'package:flutter/material.dart';
import 'package:paymob/paymob_service/paymob_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PayMopScreen extends StatelessWidget {
  const PayMopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PayMob Flutter '),
        ),
        body: ElevatedButton(onPressed: _pay, child: const Text('Tap to Pay')));
  }

  Future<void> _pay() async {
    PaymobService().getPaymentKey(100, 'EGP').then((String paymentKey) {
      launchUrl(Uri.parse(
          'https://accept.paymob.com/api/acceptance/iframes/878936?payment_token=$paymentKey'));
    });
  }
}
