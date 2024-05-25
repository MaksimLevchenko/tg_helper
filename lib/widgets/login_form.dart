import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required TextEditingController phoneController,
    required FocusNode phoneFocusNode,
    required FocusNode countryFocusNode,
    required TextEditingController countryController,
    required countryFieldKey,
    required this.context,
    required formKey,
  })  : _phoneController = phoneController,
        _phoneFocusNode = phoneFocusNode,
        _countryFocusNode = countryFocusNode,
        _countryController = countryController,
        _countryFieldKey = countryFieldKey,
        _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _phoneController;
  final FocusNode _phoneFocusNode;
  final TextEditingController _countryController;
  final FocusNode _countryFocusNode;
  final BuildContext context;
  final GlobalKey _countryFieldKey;

  final BorderSide enabledBorderSide = const BorderSide(
    color: Colors.white,
    width: 2,
  );

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _keepMeLoggedIn = true;
  bool _isPhoneValid = true;
  bool _isCountryValid = true;

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
          countryField(),
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

  Widget countryField() {
    late final Color labelColor;
    if (_isCountryValid) {
      labelColor = widget._countryFocusNode.hasFocus
          ? DarkThemeAppColors.primaryColor
          : DarkThemeAppColors.unfocusedTextColor;
    } else {
      labelColor = Colors.red;
    }
    return textSearchField(labelColor);
  }

  TextFormField textSearchField(Color labelColor) {
    return TextFormField(
      key: widget._countryFieldKey,
      controller: widget._countryController,
      focusNode: widget._countryFocusNode,
      onTap: () {},
      decoration: InputDecoration(
        labelText: 'Country',
        labelStyle: AppTextStyle.textStyle.copyWith(color: labelColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: widget.enabledBorderSide,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          _isCountryValid = false;
          return 'Please enter your country';
        }
        if (!Countries.countries.any((element) => element['name'] == value)) {
          _isCountryValid = false;
          return 'Please enter a valid country';
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
          setState(() {});
        }
      },
      child: const Text('NEXT', style: AppTextStyle.textStyle),
    );
  }

  TextFormField numberField(BorderSide enabledBorderSide) {
    late final Color labelColor;
    if (_isPhoneValid) {
      labelColor = widget._phoneFocusNode.hasFocus
          ? DarkThemeAppColors.primaryColor
          : DarkThemeAppColors.unfocusedTextColor;
    } else {
      labelColor = Colors.red;
    }
    late final String countryCode;
    if (widget._countryController.text.isEmpty) {
      countryCode = '';
    } else {
      try {
        final country = Countries.countries.firstWhere(
            (element) => element['name'] == widget._countryController.text);
        countryCode = country['code']!;
      } catch (e) {
        countryCode = '';
      }
    }
    return TextFormField(
      decoration: InputDecoration(
        prefixText: '$countryCode ',
        prefixStyle: AppTextStyle.textStyle.copyWith(fontSize: 17.5),
        labelText: 'Number',
        labelStyle: AppTextStyle.textStyle.copyWith(color: labelColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: enabledBorderSide,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),
      onChanged: (value) => setState(() {}),
      style: AppTextStyle.textStyle,
      autofocus: false,
      controller: widget._phoneController,
      focusNode: widget._phoneFocusNode,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          _isPhoneValid = false;
          return 'Please enter your phone number';
        }
        if (!value.contains(RegExp(r'^[0-9]{10}$'))) {
          _isPhoneValid = false;
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }
}
