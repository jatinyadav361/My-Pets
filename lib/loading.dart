import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {

  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.75),
      child: SpinKitThreeBounce(
        color: Colors.blueAccent,
        size: 30,
      ),
    );
  }
}
