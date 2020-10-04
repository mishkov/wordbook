import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wordbook/database/database.dart';
import 'package:wordbook/database/settings_model.dart';
import 'package:wordbook/services/theme_controller.dart';
import 'dart:ui';

import '../services/app_localizations.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String currentThemeValue;

  @override
  Widget build(BuildContext context) => Container(
        color: ThemeController().getColor("settings_page_background"),
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
                              .translate('settings_page_title'),
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
                  child: FutureBuilder<Settings>(
                    future: DBProvider.db.getAllSettings(),
                    builder: (context, settings) {
                      if (settings.hasData) {
                        currentThemeValue = settings.data.getValueOf('Theme');

                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('theme_setting'),
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: ThemeController()
                                        .getColor("settings_page_content_text"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: ThemeController()
                                        .getColor("dropdown_background"),
                                  ),
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                    top: 8.5,
                                    right: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: ThemeController()
                                              .getColor("dropdown_background"),
                                        ),
                                        child: DropdownButton<String>(
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: ThemeController()
                                                .getColor("dropdown_text"),
                                          ),
                                          onChanged: (String value) async {
                                            await DBProvider.db
                                                .setSetting('Theme', value);
                                            await ThemeController().load(value);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PagesView()),
                                            );
                                          },
                                          isDense: true,
                                          iconSize: 30,
                                          iconEnabledColor: ThemeController()
                                              .getColor('dropdown_icon'),
                                          iconDisabledColor: ThemeController()
                                              .getColor('dropdown_icon'),
                                          value: currentThemeValue,
                                          items: List.generate(
                                            ThemeController().themeOptionsCount,
                                            (index) => DropdownMenuItem<String>(
                                              value: ThemeController()
                                                  .themes[index],
                                              child: Container(
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('themes')
                                                      .split(',')[index],
                                                  style: TextStyle(
                                                    color: ThemeController()
                                                        .getColor(
                                                            "dropdown_text"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          focusColor: ThemeController()
                                              .getColor("dropdown_background"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
