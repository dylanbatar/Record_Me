import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record_me/src/models/categoriesModel.dart';
import 'package:record_me/src/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController noteController;
TextEditingController titleController;
String dropdownValue = 'All';

class NewNotePage extends StatelessWidget {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final Function saveNote = (context) async {
    if (noteController.text.length > 1 && titleController.text.length > 1) {
      SharedPreferences prefs = await _prefs;
      var noteData = {
        "title": titleController.text,
        "note": noteController.text,
        "category": dropdownValue,
        "starred": false,
      };

      //Save to Device
      prefs.setString(titleController.text, jsonEncode(noteData)).then(
          (success) => success ? Navigator.pop(context) : print('Note Error'));
    } else {
      Fluttertoast.showToast(
          msg: "The note or his title cannot be empty",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 18.0);
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Appbar(
            icon: FontAwesomeIcons.edit,
            label: 'New Note:',
            back: true,
            dropdown: false,
            action: () => saveNote(context),
          ),
          Expanded(child: _NoteWritter()),
        ],
      ),
    );
  }
}

class _NoteWritter extends StatefulWidget {
  @override
  __NoteWritterState createState() => __NoteWritterState();
}

class __NoteWritterState extends State<_NoteWritter> {
  bool isWriting = false;

  @override
  void initState() {
    noteController = new TextEditingController();
    titleController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Column(
          children: [
            Container(
              height: 35,
              margin: EdgeInsets.only(bottom: 15),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      cursorColor: Colors.grey[600],
                      cursorRadius: Radius.circular(100),
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                          labelText: 'Note title',
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                  ),
                  _CategorySelector()
                ],
              ),
            ),
            Expanded(
              child: TextField(
                maxLines: 100,
                onTap: () => setState(() => isWriting = true),
                onEditingComplete: () {
                  setState(() => isWriting = false);
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                },
                onSubmitted: (value) {},
                onChanged: (text) => setState(() {}),
                controller: noteController,
                cursorColor: Colors.grey[600],
                cursorRadius: Radius.circular(100),
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                    counter: Text(noteController.text.split(" ").length > 1
                        ? '${noteController.text.split(" ").length} words'
                        : ''),
                    contentPadding: EdgeInsets.all(20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatefulWidget {
  @override
  __CategorySelectorState createState() => __CategorySelectorState();
}

class __CategorySelectorState extends State<_CategorySelector> {
  @override
  Widget build(BuildContext context) {
    List categories = context.watch<CategoriesModel>().categories;

    return Tooltip(
      message: 'Categories',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButton<String>(
          underline: SizedBox(),
          value: dropdownValue,
          icon: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 12,
            ),
          ),
          iconSize: 24,
          elevation: 16,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: [
            ...List.generate(
              categories.length,
              (i) => DropdownMenuItem<String>(
                value: categories[i]['name'],
                child: Row(
                  children: [
                    Text(
                      categories[i]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
