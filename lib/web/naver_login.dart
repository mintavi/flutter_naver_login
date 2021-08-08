@JS()
library naver_login;

import 'dart:html';
import 'package:js/js.dart';

// let Dart call 'naver_id_login' JS calss as 'naver_id_login' Dart class
@JS()
class naver_id_login {
  external naver_id_login(String client_id, String callback_url);

  external dynamic get oAuthParams;
  external bool get is_callback;
  external String get client_id;

  external String getAccessToken();
  
  external dynamic getProfileData(String type);

  external void setButton(String color, int type, int height);
  external void setDomain(String domain);
  external void setPopup(bool popup);
  external void setState(String state);

  external String getUniqState();
  external String getLocalStorageItemSafely();
  external void setStateStore();

  external String getNaverIdLoginLink();
  external void init_naver_id_login();
  external bool checkStateStore(String state);
  external String? getCookie();

  external List<String> parseCallBack();
  external void parseCallback_check();
  external void init_naver_id_login_callback();
  external void get_naver_userprofile(String callback);
}

@JS()
class console {
  external static void log(dynamic obj);
}

@JS()
external String getProfileData(String type);



// let JS call '_dartCallback' Dart function as 'jsCallback' JS function
@JS('jsCallback')
external set jsCallback(Function f);

// @JS()
// external void _jsCallback();

@JS()
class window {
  external static dynamic get opener;
  external static dynamic open(String url, String name);
  external static dynamic close();
}