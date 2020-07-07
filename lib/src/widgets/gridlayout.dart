import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:record_me/src/pages/notePage.dart';

class GridLayout extends StatelessWidget {
  final List items;
  final Color color;

  GridLayout({
    @required this.items,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: items.length,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (BuildContext context, int index) {
        if (jsonDecode(items[index])["theme"] != null) return SizedBox();

        return _FloatingTile(
          note: jsonDecode(items[index]),
          index: index,
          color: color,
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
    );
  }
}

class _FloatingTile extends StatelessWidget {
  final Color color;
  final int index;
  final note;
  const _FloatingTile({
    @required this.note,
    this.index,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (_) => NotePage(note: note))),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withOpacity(.7),
            borderRadius: BorderRadius.circular(25)),
        child: Center(
          child: Column(
            children: [
              Text(
                '${note["title"]}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${note["note"]}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
