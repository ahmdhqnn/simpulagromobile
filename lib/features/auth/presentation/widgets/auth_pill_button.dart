import 'package:flutter/material.dart';

class AuthPillButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const AuthPillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  State<AuthPillButton> createState() => _AuthPillButtonState();
}

class _AuthPillButtonState extends State<AuthPillButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double delay = index * 0.2;
        double value = (_controller.value - delay) % 1;

        double translateY = -8 * (value < 0.5 ? value * 2 : (1 - value) * 2);

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF1D1D1D),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.loading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,

        height: 60,

        width: widget.loading ? 97 : double.infinity,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),

        child: Center(
          child: widget.loading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildDot(0),
                    const SizedBox(width: 6),
                    buildDot(1),
                    const SizedBox(width: 6),
                    buildDot(2),
                  ],
                )
              : Text(
                  widget.text,
                  style: const TextStyle(
                    fontFamily: "Plus Jakarta Sans",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
        ),
      ),
    );
  }
}
