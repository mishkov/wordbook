import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wordbook/main.dart';
import 'package:wordbook/services/theme_controller.dart';
import 'dart:ui';

import '../services/app_localizations.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: ThemeController().getColor("about_app_page_background"),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 6,
            sigmaY: 6,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  padding: EdgeInsets.all(6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PagesView()),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ThemeController().getColor("app_bar_button"),
                          size: 38,
                        ),
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('about_page_title'),
                          style: TextStyle(
                            fontSize: 26,
                            color: ThemeController().getColor("app_bar_title"),
                          ),
                        ),
                      ),
                      //just for right alignment
                      Container(
                        width: 34,
                        height: 34,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 10,
                  ),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('about_page_content'),
                    style: TextStyle(
                      fontSize: 22,
                      color: ThemeController()
                          .getColor("about_app_page_content_text"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
