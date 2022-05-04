import 'package:flutter/material.dart';

class CardLayout extends StatefulWidget {
  final onTapped;
  final String text;

  CardLayout({this.onTapped,this.text});

  @override
  _CardLayoutState createState() => _CardLayoutState();
}

class _CardLayoutState extends State<CardLayout> with TickerProviderStateMixin{
  AnimationController controller;
  Animation anim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    CurvedAnimation curvedAnimation = CurvedAnimation(parent: controller,curve: Curves.linear);
    Tween curveTween = Tween(begin: 1,end: 0.5);
    anim = curveTween.animate(curvedAnimation)..addListener((){
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Color c1 = Colors.purple;
  Color c2 = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              c1,
              c2,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        width: MediaQuery.of(context).size.width / 2 - 20,
        child: GestureDetector(
          onTap: widget.onTapped,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }
}
