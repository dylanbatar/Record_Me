import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record_me/src/widgets/appbar.dart';
import 'package:record_me/src/widgets/gridlayout.dart';
import 'package:shared_preferences/shared_preferences.dart';

var icons = {
  "dot": Icons.brightness_1,
  "alarm": Icons.access_alarms,
  "watch": Icons.watch_later,
  "track": Icons.audiotrack,
  "gamepad": Icons.gamepad,
  "joystick": FontAwesomeIcons.gamepad,
  "fastfood": Icons.fastfood,
};

class NotesPage extends StatefulWidget {
  final category;

  NotesPage({this.category = const {}});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List notes = [];
  bool isLoading = true;
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  loadNotes() async {
    SharedPreferences prefs = await _prefs;
    List keys = prefs.getKeys().toList();
    keys.remove('myCategories');
    keys.forEach((key) {
      notes.add(prefs.get(key));
    });
    if (widget.category["name"] != 'All')
      notes.removeWhere(
        (note) => (jsonDecode(note)["category"] != widget.category["name"]),
      );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 200,
            left: -45,
            child: FaIcon(
              icons[widget.category["icon"]],
              size: 150,
              color: Color(widget.category["color"]).withOpacity(.5),
            ),
          ),
          Positioned(
            bottom: -20,
            right: -120,
            child: FaIcon(
              icons[widget.category["icon"]],
              size: 350,
              color: Color(widget.category["color"]).withOpacity(.3),
            ),
          ),
          Column(
            children: [
              Appbar(
                back: true,
                action: () {},
                label: widget.category["name"] + ' notes',
              ),
              isLoading
                  ? Text('Cargando')
                  : Expanded(
                      child: GridLayout(
                        items: notes,
                        color: Color(widget.category["color"]),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
