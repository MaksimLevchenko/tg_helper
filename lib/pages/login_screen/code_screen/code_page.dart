import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tg_helper/res/app_icons.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:tdlib/td_api.dart' as td;

class LoginCodePage extends StatelessWidget {
  LoginCodePage({super.key});
  final codeController = TextEditingController();

  Widget logo() {
    return Image.asset(
      AppIcons.logoIconPath,
      width: 120,
      height: 120,
    );
  }

  Widget helperText() {
    return const Text(
      'Welcome to the Helper Text',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget codeTextField() {
    return TextField(
      controller: codeController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Enter code',
        border: OutlineInputBorder(),
      ),
      maxLength: 6,
    );
  }

  Widget sendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSendTap(context);
      },
      child: const Text('Send'),
    );
  }

  void onSendTap(BuildContext context) {
    String code = codeController.text;
    log(code);
    if (code.length < 3) {
      return;
    }
    Utils.client!.send(td.CheckAuthenticationCode(code: code));
    if (Utils.authorizationState.runtimeType ==
        td.AuthorizationStateWaitRegistration) {
      //TODO make registration page
      Utils.client!.send(td.RegisterUser(
          firstName: 'test', lastName: 'test', disableNotification: false));
    }
    if (Utils.authorizationState.runtimeType == td.AuthorizationStateReady) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            logo(),
            helperText(),
            codeTextField(),
            sendButton(context),
          ],
        ),
      ),
    );
  }
}
