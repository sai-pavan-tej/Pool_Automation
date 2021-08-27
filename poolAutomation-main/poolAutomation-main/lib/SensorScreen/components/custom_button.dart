import 'package:pool_automation_system/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.color,
    this.size,
    this.title,
    this.press,
    this.w,
    this.h,
    this.fsize,
    this.status,
  }) : super(key: key);

  final Color color;
  final Size size;
  final String title;
  final double w;
  final double h;
  final double fsize;
  final GestureTapCallback press;
  final int status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: size.height * h,
        width: size.width * w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color == kOrangeColor
                  ? kOrangeColor.withOpacity(0.5)
                  : Colors.grey[200].withOpacity(0.2),
              blurRadius: color == kOrangeColor ? 15 : 0,
              offset: color == kOrangeColor ? Offset(0, 12) : Offset(0, 0),
            ),
            BoxShadow(
              color: color == kOrangeColor
                  ? kOrangeColor.withOpacity(0.5)
                  : Colors.grey[200].withOpacity(0.2),
              blurRadius: color == kOrangeColor ? 40 : 0,
              offset: color == kOrangeColor ? Offset(-3, -3) : Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: fsize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
