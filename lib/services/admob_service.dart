import 'dart:io';

class AdMobService {
  String getAdMobAppId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8743953761460890~8146958538';
    } else {
      return null;
    }
  }

  String getTestResultPageBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8743953761460890/4389167615';
    } else {
      return null;
    }
  }

  String getAddWordDialogBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8743953761460890/9468984348';
    } else {
      return null;
    }
  }

  String getTestBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return null;
    }
  }
}