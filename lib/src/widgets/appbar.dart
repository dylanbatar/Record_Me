import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record_me/src/models/themeModel.dart';

class Appbar extends StatefulWidget {
  final bool back;
  final bool dropdown;
  final Function action;
  final IconData icon;
  final String label;

  Appbar({
    this.back = false,
    this.dropdown = true,
    this.icon = FontAwesomeIcons.ellipsisV,
    this.label = 'Record Me',
    this.action,
  });

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: FadeInLeft(
        child: Container(
          width: double.infinity,
          height: 80,
          padding: EdgeInsets.only(
            left: widget.back ? 5 : 15,
            right: widget.dropdown ? 0 : 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.back) ...[
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                          ),
                        ),
                      ),
                      SizedBox(width: 5)
                    ],
                    Expanded(
                      child: Text(
                        widget.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.dropdown
                  ? Expanded(
                      flex: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: PopupMenuButton<String>(
                          icon: FaIcon(widget.icon),
                          onSelected: (value) {
                            switch (value) {
                              case 'theme':
                                context.read<ThemeModel>().changeTheme();
                                break;
                            }
                          },
                          itemBuilder: (c) => [
                            PopupMenuItem<String>(
                              value: 'theme',
                              child: Row(
                                children: [
                                  Text(
                                    'Change Theme',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.brightness_4)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: widget.action != null ? widget.action : () {},
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(
                          widget.icon,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
