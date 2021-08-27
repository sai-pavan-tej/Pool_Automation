import 'package:pool_automation_system/constants.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatefulWidget {
  const ControlButton({
    Key key,
    @required this.size,
    this.icon,
    this.title,
    this.color
  }) : super(key: key);

  final Size size;
  final IconData icon;
  final String title;
  final Color color;
  @override
  _ControlButtonState createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.size.height * 0.08,
          width: widget.size.width * 0.15,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5)
                   ,
                blurRadius: 30,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color:
               Colors.white,
            size: 35,
          ),
        ),
        SizedBox(height: widget.size.height * 0.005),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kDarkGreyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
