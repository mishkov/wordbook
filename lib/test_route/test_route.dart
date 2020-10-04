import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordbook/database/wordbook_model.dart';
import 'package:wordbook/services/theme_controller.dart';
import 'package:wordbook/test_route/test_result_route.dart';
import '../services/app_localizations.dart';
import '../database/database.dart';
import '../main.dart';

enum TranslationDirection {
  originalToTranslation,
  translationToOriginal,
}

class WordsOfTest {
  String askedWord;
  List<String> answers;

  WordsOfTest({this.askedWord, this.answers});
}

class ColorsOfAnswer {
  Color background;
  Color text;

  ColorsOfAnswer() {
    background = ThemeController().getColor("test_page_not_selected_answer");
    text = ThemeController().getColor("test_page_not_selected_answer_text");
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _answersLength = 4;
  var _learnedWordsCount;
  var _blueButtonText;
  var _wasBlueButtonPressed;
  var _colorsOfAnswers;
  Future<WordsOfTest> _wordsOfTest;
  int _selectedAnswerIndex;
  Word _correctWord;
  var _correctAnswerIndex;
  bool _showResultButton;
  var _translationDirection;

  @override
  void initState() {
    super.initState();
    _learnedWordsCount = 0;
    _wasBlueButtonPressed = false;
    _colorsOfAnswers = List.generate(
      _answersLength,
      (index) => ColorsOfAnswer(),
    );
    _showResultButton = false;
    _translationDirection = TranslationDirection.originalToTranslation;
    _initNewWords();
  }

  //just for nice init _blueTextButton
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blueButtonText =
        AppLocalizations.of(context).translate('test_page_check_button');
  }

  Future<WordsOfTest> _getNewWordsOfTest() async {
    final words = await DBProvider.db.getRandomWords(_answersLength);
    final randomGenerator = Random();
    _correctAnswerIndex = randomGenerator.nextInt(words.length);
    _correctWord = words[_correctAnswerIndex];

    if (_translationDirection == TranslationDirection.originalToTranslation) {
      return WordsOfTest(
        askedWord: words[_correctAnswerIndex].original,
        answers: List.generate(
          words.length,
          (index) => words[index].translations.first,
        ),
      );
    } else {
      return WordsOfTest(
        askedWord: words[_correctAnswerIndex].translations.first,
        answers: List.generate(
          words.length,
          (index) => words[index].original,
        ),
      );
    }
  }

  void _initNewWords() {
    _selectedAnswerIndex = 0;
    _wordsOfTest = _getNewWordsOfTest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController().getColor("background"),
      extendBodyBehindAppBar: true,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<WordsOfTest>(
          future: _wordsOfTest,
          builder: (BuildContext context, AsyncSnapshot<WordsOfTest> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)
                        .translate('test_page_not_found_label'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: ThemeController()
                          .getColor("test_page_not_found_label"),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40525252),
                              blurRadius: 9,
                            ),
                          ],
                        ),
                        child: RaisedButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          color: ThemeController()
                              .getColor("test_page_back_button"),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 55,
                          ),
                          elevation: 0,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('test_page_back_button'),
                            style: TextStyle(
                              color: ThemeController()
                                  .getColor("test_page_back_button_text"),
                              fontSize: 25,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PagesView()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)
                            .translate('test_page_ask_label')
                            .replaceAll('\$askedWord', snapshot.data.askedWord),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color:
                              ThemeController().getColor("test_page_ask_label"),
                        ),
                      ),
                      Container(
                        height: 270,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.answers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                left: 9,
                                right: 9,
                                bottom: 9,
                              ),
                              decoration: BoxDecoration(
                                color: _colorsOfAnswers[index].background,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _colorsOfAnswers[index].background !=
                                        Colors.transparent
                                    ? [
                                        BoxShadow(
                                          color: Color(0x40525252),
                                          blurRadius: 9.09090909,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Radio(
                                  activeColor: ThemeController()
                                      .getColor("test_page_radio_button"),
                                  focusColor: ThemeController()
                                      .getColor("test_page_radio_button"),
                                  hoverColor: ThemeController()
                                      .getColor("test_page_radio_button"),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: index,
                                  groupValue: _selectedAnswerIndex,
                                  onChanged: _setSelectedAnswer,
                                ),
                                onTap: () => _setSelectedAnswer(index),
                                title: Text(
                                  snapshot.data.answers[index],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: _colorsOfAnswers[index].text,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                .getColor("test_page_check_button"),
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 55,
                            ),
                            elevation: 0,
                            child: Text(
                              _blueButtonText,
                              style: TextStyle(
                                color: ThemeController()
                                    .getColor("test_page_check_button_text"),
                                fontSize: 25,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            onPressed: _checkAnswer,
                          ),
                        ),
                        Visibility(
                          visible: _showResultButton,
                          child: Container(
                            //margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x40525252),
                                  blurRadius: 9,
                                ),
                              ],
                            ),
                            child: RaisedButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: ThemeController()
                                  .getColor("test_page_result_button"),
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 60,
                              ),
                              elevation: 0,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('test_page_result_button'),
                                style: TextStyle(
                                  color: ThemeController()
                                      .getColor("test_page_result_button_text"),
                                  fontSize: 27,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestResultPage(
                                            learnedWordsCount:
                                                _learnedWordsCount,
                                          )),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          //margin: EdgeInsets.all(27),
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
                                .getColor("test_page_change_asked_word_button"),
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 36,
                            ),
                            elevation: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Ä',
                                  style: TextStyle(
                                    color: ThemeController().getColor(
                                        "test_page_change_asked_word_button_text"),
                                    fontSize: 20,
                                  ),
                                ),
                                Icon(
                                  Icons.cached,
                                  size: 20,
                                  color: ThemeController().getColor(
                                      "test_page_change_asked_word_button_text"),
                                ),
                                Text(
                                  'A',
                                  style: TextStyle(
                                    color: ThemeController().getColor(
                                        "test_page_change_asked_word_button_text"),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            onPressed: _onDirectionChange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _setSelectedAnswer(num index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _onDirectionChange() {
    if (_translationDirection == TranslationDirection.translationToOriginal) {
      _translationDirection = TranslationDirection.originalToTranslation;
    } else {
      _translationDirection = TranslationDirection.translationToOriginal;
    }
    _setPageToDefault();
    _initNewWords();
    setState(() {});
  }

  void _setPageToDefault() {
    _colorsOfAnswers.forEach((element) {
      element.background =
          ThemeController().getColor("test_page_not_selected_answer");
      element.text =
          ThemeController().getColor("test_page_not_selected_answer_text");
    });
    _blueButtonText =
        AppLocalizations.of(context).translate('test_page_check_button');
  }

  void _checkAnswer() {
    if (_wasBlueButtonPressed) {
      _setPageToDefault();
      _initNewWords();
      _wasBlueButtonPressed = false;
    } else {
      if (_selectedAnswerIndex == _correctAnswerIndex) {
        _learnedWordsCount++;
        _correctWord.isLearned = 1;
        DBProvider.db.updateWord(_correctWord);
      } else {
        _colorsOfAnswers[_selectedAnswerIndex].background =
            ThemeController().getColor("test_page_incorrect_answer");
        _correctWord.isLearned = 0;
        DBProvider.db.updateWord(_correctWord);
      }
      _colorsOfAnswers[_correctAnswerIndex].background =
          ThemeController().getColor("test_page_correct_answer");
      _colorsOfAnswers[_correctAnswerIndex].text =
          ThemeController().getColor("test_page_by_correct_answer_text");
      _colorsOfAnswers[_selectedAnswerIndex].text =
          ThemeController().getColor("test_page_by_incorrect_answer_text");
      _showResultButton = true;
      _blueButtonText =
          AppLocalizations.of(context).translate('test_page_again_button');
      _wasBlueButtonPressed = true;
    }
    setState(() {});
  }
}
