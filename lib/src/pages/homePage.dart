import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record_me/src/widgets/appbar.dart';
import 'package:record_me/src/widgets/categories_slider.dart';
import 'package:record_me/src/widgets/searchbar.dart';
import 'package:record_me/src/widgets/starred_notes.dart';
import 'newNotePage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(0),
        children: [
          Appbar(),
          SearchBar(),
          SizedBox(height: 5),
          CategoriesSlider(),
          SizedBox(height: 10),
          StarredNotes(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor:
              Theme.of(context).floatingActionButtonTheme.foregroundColor,
          onPressed: () => Navigator.push(
              context, CupertinoPageRoute(builder: (context) => NewNotePage())),
          backgroundColor: Colors.redAccent,
          child: FaIcon(
            CupertinoIcons.add,
            size: 40,
          )),
    );
  }
}
