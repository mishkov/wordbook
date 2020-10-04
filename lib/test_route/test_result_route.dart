import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:wordbook/services/admob_service.dart';
import 'package:wordbook/services/theme_controller.dart';

import '../services/app_localizations.dart';
import '../main.dart';

class TestResultPage extends StatefulWidget {
  final num learnedWordsCount;

  TestResultPage({@required this.learnedWordsCount});

  @override
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  final _adMobService = AdMobService();
  @override
  void initState() {
    super.initState();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                AppLocalizations.of(context)
                    .translate('test_result_page_label')
                    .replaceFirst("\$learnedWordCount",
                        widget.learnedWordsCount.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: ThemeController().getColor("test_result_page_label"),
                ),
              ),
            ),
            AdmobBanner(
              adUnitId: _adMobService.getTestResultPageBannerAdId(),
              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
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
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: ThemeController().getColor("test_result_page_ok_button"),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 55,
                ),
                elevation: 0,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('test_result_page_ok_button'),
                  style: TextStyle(
                    color: ThemeController().getColor("test_result_page_ok_button_text"),
                    fontSize: 25,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PagesView()),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(27),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40525252),
                    blurRadius: 9.09090909,
                  ),
                ],
              ),
              child: RaisedButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: ThemeController().getColor("test_result_page_again_button"),
                padding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 36,
                ),
                elevation: 0,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('test_result_page_again_button'),
                  style: TextStyle(
                    color: ThemeController().getColor("test_result_page_again_button_text"),
                    fontSize: 20,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PagesView(pageIndex: 1)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
