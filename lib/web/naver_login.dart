@JS()
library naver_login;

import 'package:js/js.dart';

@JS()
class naver_id_login {
  external naver_id_login(String client_id, String callback_url);

  external void init_naver_id_login();
  external void get_naver_userprofile(String callback);

  external List<dynamic> oauthParams;
  external String getUniqState();
  external String getState();
  external String getAccessToken();
  external dynamic getProfileData(String type);

  external void setDomain(String domain);
  external void setState(String state);
  external void setPopup(bool popup);
}