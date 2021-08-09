@JS()
library naver_login;

import 'package:js/js.dart';

@JS()
class naver_id_login {
  external naver_id_login(String client_id, String callback_url);

  external dynamic get oAuthParams;
  external bool get is_callback;
  external String get client_id;
  external dynamic get oauthParams;

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

// @JS()
// external String getProfileData(String type);

@JS('jsCallback')
external set jsCallback(Function f);

@JS()
class window {
  external static dynamic open(String url, String name);
  external static dynamic close();
}