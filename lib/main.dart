import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:record_me/src/models/starredModel.dart';

import 'src/models/categoriesModel.dart';
import 'src/models/themeModel.dart';
import 'src/pages/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CategoriesModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => StarredModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeModel(),
          )
        ],
        child: Builder(
          builder: (context) {
            bool isDark = context.watch<ThemeModel>().isDark;
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      isDark ? Brightness.dark : Brightness.light,
                  statusBarBrightness:
                      isDark ? Brightness.dark : Brightness.light),
            );

            return MaterialApp(
                title: 'Record Me',
                debugShowCheckedModeBanner: false,
                theme: isDark ? ThemeData.dark() : ThemeData.light(),
                home: HomePage());
          },
        ),
      );
}
