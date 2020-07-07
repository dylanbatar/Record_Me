import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController controller;
  bool isWriting = false;

  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  unfocusAll() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }

  @override
  void dispose() {
    unfocusAll();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: 35,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () => setState(() => isWriting = true),
                onEditingComplete: () {
                  setState(() => isWriting = false);
                  unfocusAll();
                },
                onSubmitted: (value) {},
                controller: controller,
                cursorColor: Colors.grey[600],
                cursorRadius: Radius.circular(100),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    suffixIcon: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: isWriting ? 70 : 35,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: isWriting ? () {} : null,
                            child: Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          if (isWriting)
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => controller.clear(),
                              child: Container(
                                width: 35,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    labelText: 'Category or note title',
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
