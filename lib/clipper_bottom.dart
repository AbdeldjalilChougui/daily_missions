import 'package:flutter/cupertino.dart';

class ClipBottom extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.moveTo(0,0);
    p.lineTo(0,size.height - 30);
    p.quadraticBezierTo(5, size.height, 30, size.height);

    p.lineTo(size.width / 3 - 30,size.height);
    p.quadraticBezierTo(size.width / 3 , size.height + 5, size.width / 3, size.height - 30);

    p.quadraticBezierTo(size.width / 3, size.height + 5, size.width / 3 + 30, size.height);
    p.lineTo(size.width * 2 / 3 - 30,size.height);

    p.quadraticBezierTo(size.width * 2 / 3 , size.height + 5, size.width * 2 / 3, size.height - 30);

    p.quadraticBezierTo(size.width * 2 / 3, size.height + 5, size.width * 2 / 3 + 30, size.height);

    p.lineTo(size.width - 30,size.height);
    p.quadraticBezierTo(size.width - 5, size.height, size.width, size.height - 30);

    p.lineTo(size.width,0);


    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}