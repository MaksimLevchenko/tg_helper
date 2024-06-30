import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/models/account.dart';
import 'package:flutter_tg_helper/res/countries.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';
import 'package:provider/provider.dart';
import 'package:tdlib/td_api.dart' as td;

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required FocusNode phoneFocusNode,
    required FocusNode countryFocusNode,
    required TextEditingController countryController,
    required countryFieldKey,
    required formKey,
  })  : _phoneFocusNode = phoneFocusNode,
        _countryFocusNode = countryFocusNode,
        _countryController = countryController,
        _countryFieldKey = countryFieldKey,
        _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final FocusNode _phoneFocusNode;
  final TextEditingController _countryController;
  final FocusNode _countryFocusNode;
  final GlobalKey _countryFieldKey;

  final BorderSide enabledBorderSide = const BorderSide(
    color: Colors.white,
    width: 2,
  );

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPhoneValid = true;
  bool _isCountryValid = true;

  @override
  void initState() {
    super.initState();
    widget._phoneFocusNode.addListener(() {
      log('Phone focus: ${widget._phoneFocusNode.hasFocus}');
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
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
          Provider.of<Account>(context).number.toString().length > 5
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
            value: Provider.of<Account>(context).keepMeLoggedIn,
            onChanged: (value) {
              Provider.of<Account>(context, listen: false).keepMeLoggedIn =
                  value!;
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
      onChanged: (value) {
        if (value.isEmpty) {
          Provider.of<Account>(context, listen: false).countryInfo = null;
        } else {
          try {
            final country = CountriesList.countries.firstWhere(
                (element) => element.name == widget._countryController.text);
            Provider.of<Account>(context, listen: false).countryInfo = country;
          } catch (e) {
            Provider.of<Account>(context, listen: false).countryInfo = null;
          }
        }
      },
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
        if (Provider.of<Account>(context, listen: false).countryInfo == null) {
          _isCountryValid = false;
          return 'Please enter a valid country';
        }
        // if (!Countries.countries.any((element) => element['name'] == value)) {
        //   _isCountryValid = false;
        //   return 'Please enter a valid country';
        // }
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
      onPressed: loginCheck,
      child: const Text('NEXT', style: AppTextStyle.textStyle),
    );
  }

  void loginCheck() {
    String prefix = Provider.of<Account>(context, listen: false)
            .countryInfo
            ?.callingCodes
            .first ??
        '';
    //TODO return prefix
    if (widget._formKey.currentState!.validate()) {
      Utils.client!
          .send(td.SetAuthenticationPhoneNumber(
              phoneNumber:
                  '${Provider.of<Account>(context, listen: false).number}'))
          .then((answer) {
        if (answer is td.TdError) {
          log('login answer: ${answer.message}');
          return;
        }
        switch (Utils.authorizationState.runtimeType) {
          case const (td.AuthorizationStateWaitCode):
            Navigator.pushNamed(context, '/login/code');
            break;
          case const (td.AuthorizationStateClosed):
            Utils.initialize();
            break;
          case const (td.TdError):
            log('after sending number ${(answer as td.TdError).message}');
            break;
          default:
            setState(() {});
        }
      });
    }
    //Navigator.pushReplacementNamed(context, '/home');
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
    String? prefix =
        Provider.of<Account>(context).countryInfo?.callingCodes.first;
    return TextFormField(
      decoration: InputDecoration(
        prefixText: prefix == null ? '' : '+$prefix ',
        prefixStyle: AppTextStyle.textStyle,
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
      onChanged: (value) {
        int? intValue = int.tryParse(value);
        Provider.of<Account>(context, listen: false).number = intValue;
      },
      style: AppTextStyle.textStyle,
      autofocus: false,
      focusNode: widget._phoneFocusNode,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          _isPhoneValid = false;
          return 'Please enter your phone number';
        }
        if (!value.contains(RegExp(r'^[0-9]*$'))) {
          _isPhoneValid = false;
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }
}
