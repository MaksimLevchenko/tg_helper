import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/models/account.dart';
import 'package:flutter_tg_helper/res/app_icons.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';
import 'package:flutter_tg_helper/pages/login_screen/login_form/login_form.dart';
import 'package:provider/provider.dart';
import 'package:tdlib/td_api.dart' as td;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneFocusNode = FocusNode();

  final _countryFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final _countryFieldKey = GlobalKey();

  final _countryController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  Text helperText() {
    return Text(
      'Please confirm your country code\n and enter your phone number.',
      maxLines: 2,
      textAlign: TextAlign.center,
      style: AppTextStyle.textStyle.copyWith(
        fontSize: 16,
        color: DarkThemeAppColors.unfocusedTextColor,
      ),
    );
  }

  Text headerText() {
    return Text('Telegram',
        style: AppTextStyle.textStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ));
  }

  Image logoImage() {
    return Image.asset(
      AppIcons.logoIconPath,
      width: 120,
      height: 120,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) => Account(),
      child: Scaffold(
        backgroundColor: DarkThemeAppColors.backgroundColor,
        body: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: ListenableProvider(
              create: (context) => _countryFocusNode,
              child: Builder(builder: (context) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 48),
                        logoImage(),
                        const SizedBox(height: 16),
                        headerText(),
                        helperText(),
                        const SizedBox(height: 48),
                        LoginForm(
                          formKey: _formKey,
                          phoneFocusNode: _phoneFocusNode,
                          countryController: _countryController,
                          countryFocusNode: _countryFocusNode,
                          countryFieldKey: _countryFieldKey,
                        ),
                      ],
                    ),
                    Provider.of<FocusNode>(context).hasFocus
                        ? SearchCountryList(
                            countryController: _countryController,
                            countryFocusNode: _countryFocusNode,
                            countryFieldKey: _countryFieldKey,
                            scrollController: scrollController,
                          )
                        : const SizedBox(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchCountryList extends StatefulWidget {
  const SearchCountryList({
    super.key,
    required this.countryController,
    required this.countryFocusNode,
    required this.countryFieldKey,
    required this.scrollController,
  });

  final TextEditingController countryController;
  final FocusNode countryFocusNode;
  final ScrollController scrollController;
  final GlobalKey countryFieldKey;

  @override
  State<SearchCountryList> createState() => _SearchCountryListState();
}

class _SearchCountryListState extends State<SearchCountryList> {
  @override
  void initState() {
    widget.countryController.addListener(listener);
    super.initState();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<td.CountryInfo> suggestionsWidgetsBuilder(
      BuildContext context, TextEditingController controller) {
    final String searchedCountries = controller.text.toLowerCase();
    final List<td.CountryInfo> acceptableCountries = [];
    log(CountriesList.countries.first.toString());
    for (var country in CountriesList.countries) {
      if (country.name.toLowerCase().contains(searchedCountries)) {
        acceptableCountries.add(country);
      }
    }
    if (acceptableCountries.isEmpty) {
      acceptableCountries.addAll(CountriesList.countries);
    }
    return acceptableCountries;
  }

  Widget searchList(BuildContext context) {
    final countries =
        suggestionsWidgetsBuilder(context, widget.countryController);
    final countryFieldBox =
        widget.countryFieldKey.currentContext?.findRenderObject() as RenderBox;
    final fieldTopPosition = countryFieldBox.localToGlobal(Offset.zero).dy +
        countryFieldBox.size.height +
        widget.scrollController.offset -
        8;

    return Container(
      margin: EdgeInsets.only(top: fieldTopPosition),
      constraints:
          const BoxConstraints(maxHeight: 450, minHeight: 50, minWidth: 0),
      decoration: BoxDecoration(
        color: DarkThemeAppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: DarkThemeAppColors.gray.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: buildCountries(countries),
    );
  }

  ListView buildCountries(List<td.CountryInfo> countries) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return ListTile(
          onTap: () {
            Provider.of<Account>(context, listen: false).countryInfo = country;
            widget.countryController.text = country.name;
            widget.countryFocusNode.unfocus();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(country.name,
              style:
                  AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w400)),
          leading: Text(getFlagFromCode(country.countryCode),
              style: const TextStyle(fontSize: 24)),
          trailing: Text('+${country.callingCodes.first}',
              style: AppTextStyle.textStyle
                  .copyWith(color: DarkThemeAppColors.unfocusedTextColor)),
        );
      },
    );
  }

  String getFlagFromCode(String countryCode) {
    final String upperCode = countryCode.toUpperCase();
    String flagEmoji = upperCode.replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flagEmoji;
  }

  @override
  Widget build(BuildContext context) {
    return searchList(context);
  }
}
