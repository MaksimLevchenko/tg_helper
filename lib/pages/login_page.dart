import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/app_icons.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkThemeAppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              const Logo(),
              const SizedBox(height: 16),
              const AppName(),
              const HelperText(),
              const SizedBox(height: 64),
              LoginForm(
                  formKey: _formKey,
                  phoneController: _phoneController,
                  phoneFocusNode: _phoneFocusNode,
                  countryFocusNode: _countryFocusNode,
                  countryController: _countryController,
                  context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class HelperText extends StatelessWidget {
  const HelperText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Please confirm your country code and enter your phone number',
        maxLines: 2,
        textAlign: TextAlign.center,
        style: AppTextStyle.textStyle.copyWith(
          fontSize: 16,
          color: DarkThemeAppColors.unfocusedTextColor,
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController phoneController,
    required FocusNode phoneFocusNode,
    required FocusNode countryFocusNode,
    required TextEditingController countryController,
    required this.context,
  })  : _formKey = formKey,
        _phoneController = phoneController,
        _phoneFocusNode = phoneFocusNode,
        _countryFocusNode = countryFocusNode,
        _countryController = countryController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _phoneController;
  final FocusNode _phoneFocusNode;
  final TextEditingController _countryController;
  final FocusNode _countryFocusNode;
  final BuildContext context;

  final BorderSide enabledBorderSide = const BorderSide(
    color: Colors.white,
    width: 2,
  );

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _keepMeLoggedIn = true;

  @override
  void initState() {
    super.initState();
    widget._phoneFocusNode.addListener(() {
      log('Phone focus: ${widget._phoneFocusNode.hasFocus}');
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget._phoneFocusNode.dispose();
    widget._countryFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          searchCountryMenu(widget.enabledBorderSide),
          const SizedBox(height: 32),
          numberField(widget.enabledBorderSide),
          const SizedBox(height: 16),
          keepMeSignedInCheckbox(),
          const SizedBox(height: 32),
          widget._phoneController.text.length > 5
              ? loginButton(context)
              : const SizedBox(),
        ],
      ),
    );
  }

  Row keepMeSignedInCheckbox() {
    return Row(
      children: [
        Checkbox(
            side: const BorderSide(
              color: DarkThemeAppColors.gray,
              width: 2,
            ),
            activeColor: DarkThemeAppColors.primaryColor,
            checkColor: DarkThemeAppColors.textColor,
            value: _keepMeLoggedIn,
            onChanged: (value) {
              setState(() {
                _keepMeLoggedIn = value!;
              });
            }),
        const SizedBox(
          width: 16,
        ),
        Text(
          'Keep me signed in',
          style: AppTextStyle.textStyle.copyWith(fontSize: 18),
        ),
      ],
    );
  }

  Widget searchCountryMenu(enabledBorderSide) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: 'Country',
        labelStyle: AppTextStyle.textStyle.copyWith(
          color: widget._countryFocusNode.hasFocus
              ? DarkThemeAppColors.primaryColor
              : DarkThemeAppColors.unfocusedTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: enabledBorderSide,
        ),
      ),
      style: AppTextStyle.textStyle,
      autofocus: false,
      focusNode: widget._countryFocusNode,
      menuMaxHeight: 500,
      items: Countries.countries
          .map((e) => DropdownMenuItem<String>(
                value: e['name'] as String,
                child: Row(
                  children: [
                    Text('${e['flag']}  '),
                    Text(e['name'] as String),
                    const Expanded(child: SizedBox()),
                    Text('(${e['code']})'),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        widget._countryController.text = value!;
        setState(() {});
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your country';
        }
        return null;
      },
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkThemeAppColors.primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        if (widget._formKey.currentState!.validate()) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter valid phone number and country code'),
            ),
          );
        }
      },
      child: const Text('NEXT', style: AppTextStyle.textStyle),
    );
  }

  TextFormField numberField(BorderSide enabledBorderSide) {
    return TextFormField(
      decoration: InputDecoration(
        prefixText: widget._countryController.text.isEmpty
            ? ''
            : '${Countries.countries.firstWhere((element) => element['name'] == widget._countryController.text)['code']} ',
        prefixStyle: AppTextStyle.textStyle,
        labelText: 'Number',
        labelStyle: AppTextStyle.textStyle.copyWith(
          color: widget._phoneFocusNode.hasFocus
              ? DarkThemeAppColors.primaryColor
              : DarkThemeAppColors.unfocusedTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: enabledBorderSide,
        ),
      ),
      onChanged: (value) => setState(() {}),
      style: AppTextStyle.textStyle,
      autofocus: false,
      controller: widget._phoneController,
      focusNode: widget._phoneFocusNode,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null) {
          return 'Please enter your phone number';
        }
        if (value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!value.contains(RegExp(r'^[0-9]{10}$'))) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }
}

class AppName extends StatelessWidget {
  const AppName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Telegram',
        style: AppTextStyle.textStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ));
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppIcons.logoIconPath,
      width: 128,
      height: 128,
    );
  }
}
