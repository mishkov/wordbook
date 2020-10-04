import 'package:flutter/material.dart';
import 'package:wordbook/services/theme_controller.dart';
import 'dart:ui';
import '../services/app_localizations.dart';
import '../menu_icon.dart';

class PrettyAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final void Function(Sorting) updater;

  PrettyAppBar({Key key, @required this.updater, this.title})
      : preferredSize = Size.fromHeight(54.9090909),
        super(key: key);

  @override
  _PrettyAppBarState createState() => _PrettyAppBarState();
}

enum Sorting { byOriginal, byTranslation, byLearned }

class _PrettyAppBarState extends State<PrettyAppBar> {
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(54.9090909),
      child: new ClipRect(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: AppBar(
            backgroundColor: ThemeController().getColor("app_bar"),
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            titleSpacing: 6.54545455,
            title: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Icon(
                    PrettyIcons.menu,
                    color: ThemeController().getColor("app_bar_button"),
                    size: 42.1818182,
                  ),
                ),
                Spacer(),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 26.1818182,
                    color: ThemeController().getColor("app_bar_title"),
                  ),
                ),
                Spacer(),
                PopupMenuButton<Sorting>(
                  color: ThemeController().getColor("dropdown_background"),
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.sort,
                    color: Color(0xFFAEAEAE),
                    size: 42.1818182,
                  ),
                  onSelected: widget.updater,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Sorting>>[
                    PopupMenuItem<Sorting>(
                      value: Sorting.byOriginal,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('sort_by_original'),
                        style: TextStyle(
                          color:
                              ThemeController().getColor("dropdown_text"),
                        ),
                      ),
                    ),
                    PopupMenuItem<Sorting>(
                      value: Sorting.byTranslation,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('sort_by_translation'),
                        style: TextStyle(
                          color:
                              ThemeController().getColor("dropdown_text"),
                        ),
                      ),
                    ),
                    PopupMenuItem<Sorting>(
                      value: Sorting.byLearned,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('sort_by_learned'),
                        style: TextStyle(
                          color:
                              ThemeController().getColor("dropdown_text"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
