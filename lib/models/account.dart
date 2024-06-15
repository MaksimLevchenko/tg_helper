import 'package:flutter/material.dart';
import 'package:tdlib/td_api.dart';

class Account extends ChangeNotifier {
  int? _number;
  set number(int? number) {
    _number = number;
    notifyListeners();
  }

  int? get number => _number;

  CountryInfo? _countryInfo;
  set countryInfo(CountryInfo? countryInfo) {
    _countryInfo = countryInfo;
    notifyListeners();
  }

  CountryInfo? get countryInfo => _countryInfo;

  bool _keepMeLoggedIn = false;
  set keepMeLoggedIn(bool value) {
    _keepMeLoggedIn = value;
    notifyListeners();
  }

  bool get keepMeLoggedIn => _keepMeLoggedIn;
}
