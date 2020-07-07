import 'package:flutter/material.dart';

class EnchancedModal extends StatelessWidget {
  final Widget header, body, footer;

  EnchancedModal({
    @required this.body,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (header != null) header,
        SizedBox(height: 10),
        body,
        SizedBox(height: 10),
        if (footer != null) footer,
      ],
    );
  }
}

class ModalTrigger extends StatelessWidget {
  final bool isDissmisible;
  final Widget modal, child;
  final double radius, elevation;
  final Color barrierColor, color;

  ModalTrigger({
    @required this.modal,
    @required this.child,
    this.isDissmisible = true,
    this.radius = 15,
    this.elevation = 3,
    this.barrierColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => showDialog(
          barrierDismissible: isDissmisible,
          barrierColor: (barrierColor != null) ? barrierColor : Colors.black54,
          context: context,
          builder: (context) => SimpleDialog(
                elevation: elevation,
                backgroundColor: (color != null)
                    ? color
                    : Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)),
                contentPadding: EdgeInsets.all(0),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: modal,
                  )
                ],
              )),
      child: child,
    );
  }
}
