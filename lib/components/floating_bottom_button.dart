import 'package:flutter/material.dart';

class FloatingBottomButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  FloatingBottomButton({
    @required this.onPressed,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        minimumSize: Size(136, 40),
      ),
      onPressed: onPressed,
      child: Text(
        label ?? 'null',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
