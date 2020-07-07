import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record_me/src/models/starredModel.dart';
import 'package:record_me/src/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotePage extends StatefulWidget {
  final note;

  NotePage({
    @required this.note,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isStarred = false;

  starNote() async {
    SharedPreferences prefs = await _prefs;

    prefs.setString(
        widget.note["title"],
        jsonEncode({
          ...widget.note,
          "starred": isStarred,
        }));

    //Set in provider
    List keys = prefs.getKeys().toList();
    keys.remove('myCategories');
    keys.remove('config');
    List starred = [];
    keys.forEach((key) {
      starred.add(prefs.get(key));
    });
    starred.removeWhere(
      (note) => (jsonDecode(note)["starred"] == false ||
          jsonDecode(note)["starred"] == null),
    );
    context.read<StarredModel>().setStarred(starred);
  }

  @override
  void initState() {
    isStarred = widget.note["starred"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Appbar(
            dropdown: false,
            back: true,
            label: '${widget.note["title"]}',
            icon:
                isStarred ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
            action: () => setState(() {
              isStarred = !isStarred;
              starNote();
            }),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: true,
              child: Container(
                margin: EdgeInsets.all(15),
                width: double.infinity,
                height: double.infinity,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  physics: BouncingScrollPhysics(),
                  children: [
                    Text(
                      '${widget.note["note"]}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
