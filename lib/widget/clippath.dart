import 'package:flutter/material.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';

class ClipPathPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: Clipper(),
      child: Container(
        width: double.infinity,
        height: 400,
        color: kColorsBlue,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage('assets/images/background.png'),
        //         fit: BoxFit.fill)),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 30,
              width: 80,
              height: 200,
              child: FadeAnimation(
                  1,
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'))),
                  )),
            ),
            Positioned(
              left: 140,
              width: 80,
              height: 150,
              child: FadeAnimation(
                  1.3,
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'))),
                  )),
            ),
            Positioned(
              right: 40,
              top: 40,
              width: 80,
              height: 150,
              child: FadeAnimation(
                  1.5,
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'))),
                  )),
            ),
            Positioned(
              child: FadeAnimation(
                  1.6,
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 4, size.height / 2, size.width / 2, size.height - 100);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height - 10,
        size.width, size.height - 100);
    // path.quadraticBeziserTo(
    // size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
