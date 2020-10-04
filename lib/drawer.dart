import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordbook/services/theme_controller.dart';
import 'package:wordbook/settings_route/settings_route.dart';
import 'dart:ui';

import 'services/app_localizations.dart';
import 'help_route/help_route.dart';
import 'about_app_route/about_app_route.dart';

class BlurDrawer extends StatelessWidget {
  void _openHelpPage(BuildContext context) {
    HelpPage page = HelpPage();
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  void _openAboutAppPage(BuildContext context) {
    AboutAppPage page = AboutAppPage();
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  void _openSettingsPage(BuildContext context) {
    SettingsPage page = SettingsPage();
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: ThemeController().getColor("drawer_color"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16),
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Text(
                  AppLocalizations.of(context).translate('drawer_title'),
                  style: TextStyle(
                    color: ThemeController().getColor("drawer_title"),
                    fontSize: 26.1818182,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 24.72727272),
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        color: ThemeController().getColor("drawer_item_icon"),
                      ),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('drawer_help_item'),
                        style: TextStyle(
                          color: ThemeController().getColor("drawer_item_text"),
                          fontSize: 22,
                        ),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.only(top: 20),
                      onTap: () {
                        _openHelpPage(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: ThemeController().getColor("drawer_item_icon"),
                      ),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('drawer_about_item'),
                        style: TextStyle(
                          color: ThemeController().getColor("drawer_item_text"),
                          fontSize: 22,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onTap: () {
                        _openAboutAppPage(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings_applications,
                        color: ThemeController().getColor("drawer_item_icon"),
                      ),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('drawer_settings_item'),
                        style: TextStyle(
                          color: ThemeController().getColor("drawer_item_text"),
                          fontSize: 22,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onTap: () {
                        _openSettingsPage(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
