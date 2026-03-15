import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPillInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final bool enabled;

  const AuthPillInput({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.enabled = true,
  });

  @override
  State<AuthPillInput> createState() => _AuthPillInputState();
}

class _AuthPillInputState extends State<AuthPillInput> {
  bool passwordOpened = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? !passwordOpened : false,
              cursorColor: const Color(0xFF1D1D1D),
              enabled: widget.enabled,
              style: const TextStyle(
                fontFamily: "Plus Jakarta Sans",
                fontSize: 14,
                color: Color(0xFF1D1D1D),
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontFamily: "Plus Jakarta Sans",
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: widget.enabled
                      ? const Color(0x7F1D1D1D)
                      : const Color(0xFF1D1D1D).withValues(alpha: 0.5),
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          if (widget.isPassword)
            GestureDetector(
              onTap: () {
                setState(() {
                  passwordOpened = !passwordOpened;
                });
              },
              child: SvgPicture.asset(
                passwordOpened
                    ? "assets/icons/eye-close-icon.svg"
                    : "assets/icons/eye-open-icon.svg",
                width: 22,
                height: 22,
              ),
            ),
        ],
      ),
    );
  }
}
