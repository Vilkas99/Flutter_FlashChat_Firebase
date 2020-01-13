import 'package:flutter/material.dart';

class BotonesWelcome extends StatelessWidget {
  BotonesWelcome({this.texto, this.miColor, this.alPresionar});

  final String texto;
  final Color miColor;
  final Function alPresionar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: miColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            alPresionar();
            //Go to login screen.
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            texto,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
