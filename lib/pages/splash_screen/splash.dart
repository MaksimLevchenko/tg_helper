import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/res/utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Utils.initialize().then((_) async {
      await CountriesList.loadCountries();
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
    });
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}