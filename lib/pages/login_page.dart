import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(text: '1001001010');
  final _passwordController = TextEditingController(text: 'password');
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Widget loginForm() {
    const BorderSide enabledBorderSide = BorderSide(
      color: Colors.white,
      width: 2,
    );
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixText: '+7',
              prefixStyle: AppTextStyle.textStyle,
              labelText: 'Number',
              counterStyle: AppTextStyle.copyWith(fontSize: 16),
              labelStyle: AppTextStyle.textStyle,
              enabledBorder: const UnderlineInputBorder(
                borderSide: enabledBorderSide,
              ),
            ),
            style: AppTextStyle.textStyle,
            autofocus: true,
            maxLength: 10,
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            onFieldSubmitted: (_) {
              _passwordFocusNode.requestFocus();
            },
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
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              counterStyle: AppTextStyle.textStyle.copyWith(fontSize: 16),
              labelStyle: AppTextStyle.textStyle,
              enabledBorder: const UnderlineInputBorder(
                borderSide: enabledBorderSide,
              ),
            ),
            obscureText: true,
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onFieldSubmitted: (_) {
              _passwordFocusNode.unfocus();
            },
            maxLength: 20,
            style: AppTextStyle.textStyle,
            validator: (value) {
              if (value == null) {
                return 'Please enter your password';
              }
              if (value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Please enter valid phone number and password'),
                  ),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainDarkBlue,
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconRow(),
              const SizedBox(height: 16),
              loginForm(),
            ],
          ),
        ),
      ),
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
