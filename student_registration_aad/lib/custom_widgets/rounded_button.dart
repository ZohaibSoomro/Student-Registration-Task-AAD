import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.onPressed,
    this.child,
    this.text = "",
    this.color = Colors.blue,
    this.maxWidth,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Widget? child;
  final String text;
  final Color color;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contraints) {
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.grey,
          onTap: onPressed,
          child: Container(
            width: maxWidth ?? contraints.maxWidth * 0.5,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(2, 2),
                    color: Colors.grey,
                  ),
                ]),
            child: child ??
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
          ),
        );
      },
    );
  }
}
