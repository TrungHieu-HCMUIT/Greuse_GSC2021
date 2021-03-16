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
    return ButtonTheme(
      minWidth: 136.0,
      height: 40.0,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
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
      ),
    );
  }
}
