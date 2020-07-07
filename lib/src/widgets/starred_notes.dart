import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record_me/src/models/starredModel.dart';
import 'package:record_me/src/models/themeModel.dart';
import 'package:record_me/src/pages/notePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarredNotes extends StatefulWidget {
  @override
  _StarredNotesState createState() => _StarredNotesState();
}

class _StarredNotesState extends State<StarredNotes> {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLoading = true;

  loadStarred() async {
    SharedPreferences prefs = await _prefs;
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
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadStarred());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeModel>().isDark;
    List starred = context.watch<StarredModel>().starred;

    return SafeArea(
      top: false,
      bottom: true,
      minimum: EdgeInsets.only(bottom: 5),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Starred Notes:',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {},
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.star,
                      size: 22,
                      color: context.watch<ThemeModel>().isDark
                          ? Colors.grey
                          : Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? Text('Loading!')
                  : ListView(
                      padding: EdgeInsets.all(0),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...List.generate(
                            starred.length,
                            (i) => InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => NotePage(
                                              note: jsonDecode(starred[i])))),
                                  child: FadeInLeft(
                                    from: 30,
                                    child: Container(
                                      width: 200,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.black38
                                            : Colors.grey[350],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${jsonDecode(starred[i])["title"]}',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '${jsonDecode(starred[i])["note"]}',
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
