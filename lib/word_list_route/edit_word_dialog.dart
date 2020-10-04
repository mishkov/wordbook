import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wordbook/services/theme_controller.dart';
import '../services/app_localizations.dart';
import '../database/database.dart';
import '../database/wordbook_model.dart';

class EditWordDialog extends StatefulWidget {
  final String wordId;
  final scaffoldKey;

  EditWordDialog(this.wordId, this.scaffoldKey);

  @override
  State<StatefulWidget> createState() => _EditWordDialogState();
}

class _EditWordDialogState extends State<EditWordDialog> {
  final _originalController = TextEditingController();
  final _translationsController = TextEditingController();

  @override
  void dispose() {
    _originalController.clear();
    _translationsController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 6,
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: ThemeController().getColor("edit_word_dialog_background"),
              boxShadow: [
                BoxShadow(color: Color(0x40525252), blurRadius: 25),
              ],
            ),
            padding: EdgeInsets.all(8),
            child: FutureBuilder<Word>(
              future: DBProvider.db.getWordById(widget.wordId),
              builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
                if (snapshot.hasData) {
                  _originalController.text = snapshot.data.original;
                  _translationsController.text =
                      snapshot.data.translationsToString();
                  return Material(
                    type: MaterialType.transparency,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12.3188406),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('original_field_name'),
                                style: TextStyle(
                                  color: ThemeController().getColor(
                                      "edit_word_dialog_original_field_name"),
                                  fontSize: 18.1818182,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: Icon(
                                Icons.clear,
                                color: ThemeController()
                                    .getColor("edit_word_dialog_close_icon"),
                                size: 21.8181818,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 4,
                            bottom: 8,
                          ),
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                              ),
                              BoxShadow(
                                color: ThemeController()
                                    .getColor("edit_word_dialog_original_field"),
                                spreadRadius: -1.8,
                                blurRadius: 3.6,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _originalController,
                            keyboardType: TextInputType.text,
                            enableSuggestions: true,
                            style: TextStyle(
                              color: ThemeController().getColor(
                                  "edit_word_dialog_original_field_text"),
                              fontSize: 18.1818182,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.3188406),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('translation_field_name'),
                            style: TextStyle(
                              color: ThemeController().getColor(
                                  "edit_word_dialog_translation_field_name"),
                              fontSize: 18.1818182,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 4,
                            bottom: 40,
                          ),
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                              ),
                              BoxShadow(
                                color: ThemeController().getColor(
                                    "edit_word_dialog_translation_field"),
                                spreadRadius: -1.8,
                                blurRadius: 3.6,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _translationsController,
                            keyboardType: TextInputType.text,
                            enableSuggestions: true,
                            style: TextStyle(
                              color: ThemeController().getColor(
                                  "edit_word_dialog_translation_field_text"),
                              fontSize: 18.1818182,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x40525252),
                                    blurRadius: 9.09090909,
                                  ),
                                ],
                              ),
                              child: RaisedButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: ThemeController()
                                    .getColor("edit_word_dialog_remove_button"),
                                padding: EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 30,
                                ),
                                elevation: 0,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('remove_word_button'),
                                  style: TextStyle(
                                    color: ThemeController().getColor(
                                        "edit_word_dialog_remove_button_text"),
                                    fontSize: 18,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                onPressed: _removeWord,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x40525252),
                                    blurRadius: 9.09090909,
                                  ),
                                ],
                              ),
                              child: RaisedButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: ThemeController()
                    .getColor("edit_word_dialog_apply_button"),
                                padding: EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 30,
                                ),
                                elevation: 0,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('apply_changes_button'),
                                  style: TextStyle(
                                    color: ThemeController()
                                        .getColor("edit_word_dialog_apply_button_text"),
                                    fontSize: 18,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                onPressed: _changeWord,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );

  void _closeDialog() {
    Navigator.pop(context, true);
  }

  void _removeWord() async {
    _closeDialog();
    await DBProvider.db.deleteWord(widget.wordId);
  }

  void _changeWord() async {
    _closeDialog();
    if (_translationsController.text.isNotEmpty &&
        _originalController.text.isNotEmpty) {
      List<String> translations = _translationsController.text.split(';');
      translations.forEach((element) => element.trim());
      await DBProvider.db.updateWord(
        Word(
          original: _originalController.text,
          translations: translations,
          isLearned: 0,
          id: widget.wordId,
        ),
      );
    } else {
      widget.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              color: ThemeController().getColor("snack_bar_background"),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(8),
            child: Text(AppLocalizations.of(context)
                .translate('why_word_is_not_edited_toast')),
          ),
        ),
      );
    }
  }
}
