import 'package:flutter/cupertino.dart';

class ClipBottom extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.moveTo(0,size.height);
    p.lineTo(0,size.height - 60);
    p.quadraticBezierTo(5, size.height - 80, 20, size.height - 80);

    p.lineTo(size.width - 20,size.height - 80);
    p.quadraticBezierTo(size.width - 5 , size.height - 80, size.width, size.height - 60);

    p.lineTo(size.width,size.height);


    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}