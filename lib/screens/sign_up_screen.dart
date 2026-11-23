import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'interests_screen.dart';

/// Sky height used by the sign-up / onboarding screens.
double onboardingSkyHeight(BuildContext context) =>
    (MediaQuery.sizeOf(context).height * 0.18).clamp(110.0, 160.0);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  List<TextEditingController> get _all => [_username, _email, _password, _confirm];

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  String? get _error {
    if (_email.text.isNotEmpty && !_email.text.contains('@')) return 'Enter a valid email address.';
    if (_password.text.isNotEmpty && _password.text.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (_confirm.text.isNotEmpty && _confirm.text != _password.text) return "Passwords don't match.";
    return null;
  }

  bool get _valid =>
      _username.text.trim().isNotEmpty &&
      _email.text.contains('@') &&
      _password.text.length >= 6 &&
      _confirm.text == _password.text;

  void _next() {
    // TODO: replace with real account creation.
    appState.signIn(email: _email.text.trim(), username: _username.text.trim());
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InterestsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    return SkyScaffold(
      showXp: false,
      skyHeight: onboardingSkyHeight(context),
      clouds: const [
        CloudSpec(x: 0.03, top: 40, width: 95, speed: 9),
        CloudSpec(x: 0.35, top: 70, width: 115, speed: 6),
        CloudSpec(x: 0.72, top: 60, width: 90, speed: 13),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.ink),
                  label: const Text('Back to log in', style: TextStyle(color: AppColors.ink, fontSize: 14)),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Sign Up', style: titleStyle, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              PillField(
                controller: _username,
                hint: 'Username',
                fillColor: AppColors.field,
                autofillHints: const [AutofillHints.newUsername],
              ),
              const SizedBox(height: 22),
              PillField(
                controller: _email,
                hint: 'Email',
                fillColor: AppColors.field,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 22),
              PillField(
                controller: _password,
                hint: 'Password',
                fillColor: AppColors.field,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
              ),
              const SizedBox(height: 22),
              PillField(
                controller: _confirm,
                hint: 'Confirm Password',
                fillColor: AppColors.field,
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 34,
                child: Center(
                  child: error == null
                      ? null
                      : Text(error, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                ),
              ),
              PillButton(label: 'Next', onPressed: _valid ? _next : null),
            ],
          ),
        ),
      ),
    );
  }
}
