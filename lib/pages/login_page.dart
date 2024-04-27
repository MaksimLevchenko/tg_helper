import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/style/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconRow(),
              SizedBox(height: 16),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const enabledBorderSide = BorderSide(
      color: Colors.white,
      width: 2,
    );
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: AppTextStyle.textStyle,
            enabledBorder: UnderlineInputBorder(
              borderSide: enabledBorderSide,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: AppTextStyle.textStyle,
            enabledBorder: UnderlineInputBorder(
              borderSide: enabledBorderSide,
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}

class IconRow extends StatelessWidget {
  const IconRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/tg_icon.png',
          width: 48,
          height: 48,
        ),
        const SizedBox(width: 16),
        Text(
          'TG Helper',
          style: AppTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
