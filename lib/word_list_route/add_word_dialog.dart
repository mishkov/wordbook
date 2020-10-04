import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wordbook/services/theme_controller.dart';
import '../services/app_localizations.dart';
import '../database/database.dart';
import '../database/wordbook_model.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:wordbook/services/admob_service.dart';

class AddWordDialog extends StatefulWidget {
  final scaffoldKey;

  AddWordDialog(this.scaffoldKey);

  @override
  State<StatefulWidget> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final _originalController = TextEditingController();
  final _translationsController = TextEditingController();
  final _adMobService = AdMobService();

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
              color: ThemeController().getColor("add_word_dialog_background"),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40525252),
                  blurRadius: 25,
                ),
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Material(
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
                                "add_word_dialog_original_field_name"),
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
                              .getColor("add_word_dialog_close_icon"),
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
                              .getColor("add_word_dialog_original_field"),
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
                        color: ThemeController()
                            .getColor("add_word_dialog_original_field_text"),
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
                        color: ThemeController()
                            .getColor("add_word_dialog_translation_field_name"),
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
                          color: ThemeController()
                              .getColor("add_word_dialog_translation_field"),
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
                        color: ThemeController()
                            .getColor("add_word_dialog_translation_field_text"),
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: ThemeController()
                          .getColor("add_word_dialog_ad_banner"),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x40525252),
                          blurRadius: 9.09090909,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 40),
                    alignment: Alignment.center,
                    child: AdmobBanner(
                      adUnitId: _adMobService.getAddWordDialogBannerAdId(),
                      adSize: AdmobBannerSize.BANNER,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 18,
                      //runAlignment: WrapAlignment.center,
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
                                .getColor("add_word_dialog_cancel_button"),
                            padding: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 30,
                            ),
                            elevation: 0,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('cancel_adding_word_button'),
                              style: TextStyle(
                                color: ThemeController()
                                    .getColor("add_word_dialog_cancel_button_text"),
                                fontSize: 18,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            onPressed: () => Navigator.pop(context, true),
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
                                .getColor("add_word_dialog_add_button"),
                            padding: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 30,
                            ),
                            elevation: 0,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('add_word_button'),
                              style: TextStyle(
                                color: ThemeController()
                                    .getColor("add_word_dialog_add_button_text"),
                                fontSize: 18,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            onPressed: _processWord,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _closeDialog() {
    Navigator.pop(context, true);
  }

  void _processWord() async {
    _closeDialog();
    if (_translationsController.text.isNotEmpty &&
        _originalController.text.isNotEmpty) {
      List<String> translations = _translationsController.text.split(';');
      translations.forEach((element) => element.trim());
      await DBProvider.db.newWord(
        Word(
            original: _originalController.text,
            translations: translations,
            isLearned: 0),
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
                .translate('why_word_is_not_added_toast')),
          ),
        ),
      );
    }
  }
}
