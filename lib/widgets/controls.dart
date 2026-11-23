import 'package:flutter/material.dart';

import '../screens/menu_screen.dart';
import '../theme.dart';

/// Rounded, shadowed button used throughout the mockups. Passing a null
/// [onPressed] shows the pale "disabled" variant (e.g. Login before the form
/// is filled in).
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.disabledColor = AppColors.primaryDisabled,
    this.textColor = Colors.white,
    this.icon,
    this.height = 46,
    this.radius,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700,
    this.alignStart = false,
    this.padding = 28,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color disabledColor;
  final Color textColor;
  final IconData? icon;
  final double height;
  final double? radius;
  final double fontSize;
  final FontWeight fontWeight;
  final bool alignStart;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final fg = enabled ? textColor : AppColors.disabledText;
    final iconSize = fontSize + 2;
    final text = Text(
      label,
      textAlign: alignStart ? TextAlign.start : TextAlign.center,
      style: TextStyle(color: fg, fontSize: fontSize, fontWeight: fontWeight),
    );
    return Material(
      color: enabled ? color : disabledColor,
      elevation: enabled ? 4 : 0,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? height / 2)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              children: [
                if (icon != null && !alignStart) SizedBox(width: iconSize),
                Expanded(child: text),
                if (icon != null) Icon(icon, color: fg, size: iconSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded text field with a drop shadow.
///
/// When [fillColor] is null the field is grey while empty and turns
/// near-white once filled in, matching the login mockups.
class PillField extends StatelessWidget {
  const PillField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.fillColor,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final fill = fillColor ??
            (value.text.isEmpty ? AppColors.fieldEmpty : AppColors.fieldFilled);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(23),
            boxShadow: const [
              BoxShadow(color: Color(0x66000000), blurRadius: 4, offset: Offset(0, 3)),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            style: const TextStyle(fontSize: 14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black87),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 34),
            ),
          ),
        );
      },
    );
  }
}

/// Hamburger button that opens the main menu.
class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Menu',
      icon: const Icon(Icons.menu, size: 34, color: AppColors.ink),
      onPressed: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const MenuScreen(),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
    );
  }
}

/// Centered page title with an optional subtitle underneath.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: titleStyle, textAlign: TextAlign.center),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: subtitleStyle, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

/// Replaces the whole navigation stack with [screen] (used for top-level
/// sections reached from the menu or after login).
void goToSection(BuildContext context, Widget screen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => screen),
    (_) => false,
  );
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
