import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';

/// A button that shows a busy indicator in place of title
class BusyButton extends StatefulWidget {
  final bool busy;
  final String title;
  final Function onPressed;
  final bool enabled;
  const BusyButton(
      {@required this.title,
      this.busy = false,
      @required this.onPressed,
      this.enabled = true});

  @override
  _BusyButtonState createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: InkWell(
        child: AnimatedContainer(
          height: widget.busy ? 50 : null,
          width: widget.busy ? 50 : null,
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: widget.busy ? 10 : 15,
              vertical: widget.busy ? 10 : 10),
          margin: EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: widget.enabled ? kPrimaryColor : Colors.grey[300],
          ),
          child: !widget.busy
              ? Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                )
              : CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        ),
      ),
    );
  }
}
