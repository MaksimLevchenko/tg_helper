import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/app_icons.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';
import 'package:flutter_tg_helper/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController(text: '1001001010');
  final _phoneFocusNode = FocusNode();
  final _countryController = TextEditingController();
  final _countryFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _countryFieldKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _countryFocusNode.addListener(() {
      setState(() {});
    });
    _countryController.addListener(() {
      setState(() {});
    });
  }

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

  List<Map<String, String>> suggestionsWidgetsBuilder(context, controller) {
    final String searchedCountrys = controller.text.toLowerCase();
    final List<Map<String, String>> acceptableCountries = [];
    for (var country in Countries.countries) {
      if (country['name']!.toLowerCase().contains(searchedCountrys)) {
        acceptableCountries.add(country);
      }
    }
    if (acceptableCountries.isEmpty) {
      acceptableCountries.addAll(Countries.countries);
    }
    return acceptableCountries;
  }

  Widget searchList() {
    final countries = suggestionsWidgetsBuilder(context, _countryController);
    final countryFieldBox =
        _countryFieldKey.currentContext?.findRenderObject() as RenderBox;
    final fieldTopPosition = countryFieldBox.localToGlobal(Offset.zero).dy +
        countryFieldBox.size.height +
        scrollController.offset -
        8;

    return Container(
      margin: EdgeInsets.only(top: fieldTopPosition),
      constraints:
          const BoxConstraints(maxHeight: 450, minHeight: 50, minWidth: 0),
      decoration: BoxDecoration(
        color: DarkThemeAppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DarkThemeAppColors.primaryColor,
          width: 2,
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return ListTile(
            onTap: () {
              _countryController.text = country['name']!;
              _countryFocusNode.unfocus();
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text(country['name']!,
                style: AppTextStyle.textStyle
                    .copyWith(fontWeight: FontWeight.w400)),
            leading:
                Text(country['flag']!, style: const TextStyle(fontSize: 24)),
            trailing: Text(country['code']!,
                style: AppTextStyle.textStyle
                    .copyWith(color: DarkThemeAppColors.unfocusedTextColor)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkThemeAppColors.backgroundColor,
      body: SingleChildScrollView(
        controller: scrollController,
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    logoImage(),
                    const SizedBox(height: 16),
                    headerText(),
                    helperText(),
                    const SizedBox(height: 48),
                    LoginForm(
                        formKey: _formKey,
                        phoneController: _phoneController,
                        phoneFocusNode: _phoneFocusNode,
                        countryFocusNode: _countryFocusNode,
                        countryController: _countryController,
                        countryFieldKey: _countryFieldKey,
                        context: context),
                  ],
                ),
                _countryFocusNode.hasFocus ? searchList() : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
