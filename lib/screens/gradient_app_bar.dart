import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  final String text;
  final bool showBackButton;

  const GradientAppBar({
    Key? key,
    required this.text,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepPurpleAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: padding),
          child: Stack(
            children: [
              showBackButton
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)))
                  : const SizedBox.shrink(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container gradientAppBar(
    String text, BuildContext context, Function() function) {
  double padding = MediaQuery.of(context).padding.top;
  return Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.pink, Colors.deepPurpleAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp)),
    child: Center(
      child: Padding(
        padding: EdgeInsets.only(top: padding),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    iconSize: 30,
                    onPressed: function,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ))),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
