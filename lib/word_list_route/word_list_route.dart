import 'package:flutter/material.dart';
import 'package:wordbook/services/theme_controller.dart';
import '../services/app_localizations.dart';
import '../database/database.dart';
import '../database/wordbook_model.dart';
import 'package:wordbook/drawer.dart';
import 'word_list_route_app_bar.dart';
import 'add_word_dialog.dart';
import 'edit_word_dialog.dart';

class WordListPage extends StatefulWidget {
  WordListPage({Key key}) : super(key: key);

  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  Sorting _sorting = Sorting.byLearned;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addWord() async {
    AddWordDialog dialog = AddWordDialog(_scaffoldKey);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          dialog,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: ThemeController().getColor("add_word_dialog_barrier"),
      transitionDuration: const Duration(milliseconds: 150),
    ).then((value) {
      setState(() {});
    });
  }

  void _editWord(String id) async {
    EditWordDialog dialog = EditWordDialog(id, _scaffoldKey);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          dialog,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: ThemeController().getColor("edit_word_dialog_barrier"),
      transitionDuration: const Duration(milliseconds: 150),
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeController().getColor("background"),
      extendBodyBehindAppBar: true,
      appBar: PrettyAppBar(
          updater: update,
          title:
              AppLocalizations.of(context).translate('word_list_page_title')),
      drawerScrimColor: Colors.transparent,
      drawer: BlurDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<Word>>(
          future: DBProvider.db.getAllWords(),
          builder: (BuildContext context, AsyncSnapshot<List<Word>> snapshot) {
            if (snapshot.hasData) {
              sortWords(snapshot.data);
              return ListView.builder(
                key: Key("wordList"),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Word item = snapshot.data[index];
                  return GestureDetector(
                    onLongPress: () {
                      _editWord(item.id);
                    },
                    child: Container(
                      margin: index == snapshot.data.length - 1
                          ? EdgeInsets.only(bottom: 83.6363636)
                          : EdgeInsets.all(0),
                      padding: EdgeInsets.all(3.63636364),
                      color: index % 2 == 0
                          ? Colors.transparent
                          : ThemeController()
                              .getColor("adjacent_background_in_list"),
                      child: Row(
                        children: <Widget>[
                          item.isLearned == 1
                              ? Icon(
                                  Icons.check_circle_outline,
                                  color: ThemeController()
                                      .getColor("learned_icon"),
                                )
                              : Container(), // just void
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    item.original,
                                    style: TextStyle(
                                      fontSize: 18.1818182,
                                      color: ThemeController()
                                          .getColor("word_text_in_list"),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    item.translations.first,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 18.1818182,
                                      color: ThemeController()
                                          .getColor("word_text_in_list"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWord,
        tooltip:
            AppLocalizations.of(context).translate('floating_button_tooltip'),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                ThemeController().getColor("floating_button_gradient_start"),
                ThemeController().getColor("floating_button_gradient_end"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Icon(
            Icons.add,
            color: ThemeController().getColor("floating_button_icon"),
          ),
        ),
      ),
    );
  }

  void sortWords(List<Word> list) {
    if (_sorting == Sorting.byOriginal) {
      list.sort((a, b) => a.original.compareTo(b.original));
    } else if (_sorting == Sorting.byTranslation) {
      list.sort((a, b) => a.translations.first.compareTo(b.translations.first));
    } else if (_sorting == Sorting.byLearned) {
      list.sort((a, b) => a.isLearned.compareTo(b.isLearned));
    }
  }

  void update(Sorting sorting) {
    _sorting = sorting;
    setState(() {});
  }
}

class PureScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
