import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'pk_test_51RQ47u2fvPZJA4JMnqCTkKp7jYNaRE7jt2a5xQwcvKUT29ePP66gDwFWfcWKSW2nbdlh9mXjAcxxeaMuxJDg1EtN00qBZLpefj';
  await Stripe.instance.applySettings();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: {
        '/welcome': (context) => WelcomePage(),
      },
    );
  }
}

