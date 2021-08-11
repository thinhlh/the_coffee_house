import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 2.5,
            color: Theme.of(context).primaryColor,
          ),
          Container(),
        ],
      ),
    );
  }
}
