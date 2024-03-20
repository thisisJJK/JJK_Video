import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final IconData iconData;
  const PlayerButton({
    required this.iconData,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30,
      color: Colors.white,
      icon: Icon(
        iconData,
      ),
    );
  }
}
