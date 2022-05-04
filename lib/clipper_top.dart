import 'package:flutter/cupertino.dart';

class ClipTop extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.moveTo(0, 0);
    p.lineTo(0, size.height / 2 + 20);
    p.quadraticBezierTo(30, size.height * 5 / 6, size.width / 2, size.height - 20);

    p.quadraticBezierTo(size.width - 30, size.height * 5 / 6, size.width, size.height / 2 + 20);
    p.lineTo(size.width,0);



    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}