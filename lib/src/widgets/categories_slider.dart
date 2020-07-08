import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:record_me/src/models/categoriesModel.dart';
import 'package:record_me/src/models/themeModel.dart';
import 'package:record_me/src/pages/notesPage.dart';
import 'package:record_me/src/widgets/enchanced_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Icons
var icons = {
  "dot": Icons.brightness_1,
  "alarm": Icons.access_alarms,
  "watch": Icons.watch_later,
  "track": Icons.audiotrack,
  "gamepad": Icons.gamepad,
  "joystick": FontAwesomeIcons.gamepad,
  "fastfood": Icons.fastfood,
};

class CategoriesSlider extends StatefulWidget {
  @override
  _CategoriesSliderState createState() => _CategoriesSliderState();
}

class _CategoriesSliderState extends State<CategoriesSlider> {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  loadCategories() async {
    SharedPreferences prefs = await _prefs;
    //Get Categories
    String cats = prefs.getString('myCategories');
    if (cats == null || cats.length == 0) {
      await prefs.setString(
          'myCategories',
          jsonEncode([
            {
              "name": "All",
              "color": Colors.grey.value,
              "icon": "dot",
            }
          ]));
      cats = prefs.getString('myCategories');
    }
    //Convert to JSON
    List categories = jsonDecode(cats).toList();

    //Set Categories
    context.read<CategoriesModel>().setCategories(categories);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCategories());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List categories = context.watch<CategoriesModel>().categories;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Categories:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
              ModalTrigger(
                modal: EnchancedModal(
                  header: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'New Category',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  body: _NewCategoryBody(),
                ),
                child: FaIcon(
                  FontAwesomeIcons.edit,
                  size: 22,
                  color: context.watch<ThemeModel>().isDark
                      ? Colors.grey
                      : Colors.grey[800],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 100,
            child: categories.length == 0
                ? Container(
                    width: 100,
                    height: 100,
                    child: Text('No categories yet!'),
                  )
                : ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...List.generate(
                          categories.length,
                          (i) => FadeInLeft(
                                from: 30,
                                child: _CategoryTile(category: categories[i]),
                              ))
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final category;

  _CategoryTile({@required this.category});

  @override
  __CategoryTileState createState() => __CategoryTileState();
}

class __CategoryTileState extends State<_CategoryTile> {
  unfocusAll() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var category = widget.category;

    return GestureDetector(
      onTap: () {
        unfocusAll();
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => NotesPage(
                category: category,
              ),
            ));
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        width: 90,
        decoration: BoxDecoration(
          color: Color(category["color"]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              category["name"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            FaIcon(
              icons[category["icon"]],
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class _NewCategoryBody extends StatefulWidget {
  @override
  __NewCategoryBodyState createState() => __NewCategoryBodyState();
}

class __NewCategoryBodyState extends State<_NewCategoryBody> {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Color pickerColor = Colors.blue[400];
  Color currentColor = Colors.blue[400];
  String dropdownValue = 'dot';
  TextEditingController controller;

  addCategory() async {
    SharedPreferences prefs = await _prefs;
    if (controller.text.length > 1) {
      CategoriesModel categoriesModel = Provider.of<CategoriesModel>(
        context,
        listen: false,
      );
      List categories = jsonDecode(prefs.get('myCategories')).toList();
      categories.add({
        "name": controller.text,
        "icon": dropdownValue,
        "color": currentColor.value,
      });
      categoriesModel.categories = categories;
      await prefs.setString('myCategories', jsonEncode(categories));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 35,
            child: TextField(
              controller: controller,
              cursorColor: Colors.grey[600],
              cursorRadius: Radius.circular(100),
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                  labelText: 'Category name',
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModalTrigger(
                child: FloatingActionButton(
                  onPressed: null,
                  child: FaIcon(
                    icons[dropdownValue],
                    color: Colors.white,
                  ),
                  backgroundColor: currentColor,
                ),
                modal: EnchancedModal(
                  header: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Pick a Color',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  body: Container(
                    child: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (newColor) =>
                            setState(() => currentColor = newColor),
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              DropdownButton<String>(
                selectedItemBuilder: (_) => [SizedBox()],
                underline: SizedBox(),
                icon: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category Icon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 8),
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 15,
                      ),
                    ),
                  ],
                ),
                value: 'dot',
                items: [
                  ...List.generate(
                      icons.length,
                      (i) => DropdownMenuItem<String>(
                            child: Row(
                              children: [
                                Text(
                                  '${icons.keys.toList()[i].toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  icons[icons.keys.toList()[i]],
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            value: icons.keys.toList()[i],
                          )),
                ],
                onChanged: (value) => setState(() => dropdownValue = value),
              )
            ],
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 40,
              color: Colors.blue,
              child: Material(
                type: MaterialType.transparency,
                color: Colors.transparent,
                elevation: 6,
                child: InkWell(
                  splashColor: Colors.white12,
                  onTap: () => addCategory(),
                  child: SizedBox.expand(
                    child: Center(
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
