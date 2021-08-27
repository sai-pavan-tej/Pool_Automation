import 'package:pool_automation_system/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.size,
    this.title,
    this.press,
    this.buttonColor,
  }) : super(key: key);

  final Size size;
  final String title;
  final GestureTapCallback press;
  final Color buttonColor ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: press,
      child: Container(
        height: size.height * 0.07,
        width: size.width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
           boxShadow: [
            BoxShadow(
              color: buttonColor == kOrangeColor ? kOrangeColor.withOpacity(0.5): Colors.grey[200].withOpacity(0.2),
              blurRadius: buttonColor == kOrangeColor ? 15 : 0,
              offset:buttonColor == kOrangeColor ?  Offset(0, 12) : Offset(0, 0),
            ),
            BoxShadow(
              color: buttonColor == kOrangeColor ? kOrangeColor.withOpacity(0.5): Colors.grey[200].withOpacity(0.2),
              blurRadius: buttonColor == kOrangeColor ? 40 : 0,
              offset: buttonColor == kOrangeColor ?Offset(-3, -3): Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: buttonColor == kOrangeColor ? Colors.black: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
