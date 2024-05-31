import 'package:flutter_tg_helper/res/utils.dart';
import 'package:tdlib/td_api.dart';

class CountriesList {
  static late final List<CountryInfo> countries;

  static Future<List<CountryInfo>> loadCountries() async {
    final Countries _ = await Utils.client!.send(const GetCountries());
    countries = _.countries;
    return countries;
  }
}
