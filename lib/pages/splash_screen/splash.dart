import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:tdlib/td_api.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Utils.initialize().then((_) async {
      await CountriesList.loadCountries();
      if (context.mounted) {
        log('auth state after splash is ${Utils.authorizationState.runtimeType}');
        switch (Utils.authorizationState.runtimeType) {
          case const (AuthorizationStateReady):
            Navigator.pushReplacementNamed(context, '/home');
            break;
          default:
            Navigator.pushReplacementNamed(context, '/login');
        }
      }
    });
    return Container(
      color: Colors.amber,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
