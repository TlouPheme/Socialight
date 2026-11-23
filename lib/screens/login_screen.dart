import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/brand_logos.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'home_shell.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool get _canLogin => _email.text.contains('@') && _password.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _email.addListener(_refresh);
    _password.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: replace with real authentication.
    appState.signIn(email: _email.text.trim());
    HomeShell.open(context);
  }

  void _social(String provider) => showSnack(context, '$provider sign-in is coming soon.');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final sky = (size.height * 0.30).clamp(170.0, 285.0);
    return SkyScaffold(
      showXp: false,
      skyHeight: sky,
      clouds: [
        CloudSpec(x: 0.15, top: sky * 0.28, width: 110, speed: 8),
        CloudSpec(x: 0.8, top: sky * 0.30, width: 100, speed: 14),
        CloudSpec(x: -0.1, top: sky * 0.6, width: 70, speed: 20),
      ],
      decorations: [
        Positioned(
          top: sky * 0.32,
          left: 0,
          right: 0,
          child: const Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
        ),
        const Positioned(bottom: 8, left: 0, right: 0, child: Center(child: TreeTop())),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 44, 36, 24),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Login', style: titleStyle, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              PillField(
                controller: _email,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 24),
              PillField(
                controller: _password,
                hint: 'Password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => showSnack(context, 'Password reset is coming soon.'),
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: AppColors.accentText, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              PillButton(label: 'Login', onPressed: _canLogin ? _login : null),
              const SizedBox(height: 32),
              const Text('Or login with', textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SocialButton(
                    label: 'Google',
                    onTap: () => _social('Google'),
                    child: const BrandLogo.google(size: 42),
                  ),
                  _SocialButton(
                    label: 'Apple',
                    onTap: () => _social('Apple'),
                    child: const BrandLogo.apple(size: 44),
                  ),
                  _SocialButton(
                    label: 'Facebook',
                    onTap: () => _social('Facebook'),
                    child: const BrandLogo.facebook(size: 44),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text("Don't have account? ", style: TextStyle(fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                    child: const Text('Sign Up', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.onTap, required this.child});

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Login with $label',
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: SizedBox(width: 56, height: 56, child: Center(child: child)),
      ),
    );
  }
}
