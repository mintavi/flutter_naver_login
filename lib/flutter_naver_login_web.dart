import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'web/inject_js_libraries.dart';
import 'web/naver_login.dart';

class FlutterNaverLoginPlugin {
  static late final String? _clientId;
  static late final String? _callbackUrl;

  static initialize() async {
    print("in initialize");
    const String naverApiUrl = 'https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js';
    const String jQueryUrl = 'http://code.jquery.com/jquery-1.11.3.min.js';
    await injectJSLibraries([naverApiUrl, jQueryUrl]);

    _clientId = html.window.document.querySelector("meta[name='naver-login-client-id']")
                    ?.getAttribute("content");
    _callbackUrl = html.window.document.querySelector("meta[name='naver-login-callback-url']")
                    ?.getAttribute("content");
    print("clientId: $_clientId");
    print("callbackUrl: $_callbackUrl");
  }

  static void registerWith(Registrar registrar) async {
    print("in registerWith");
    await initialize();
    final MethodChannel channel = MethodChannel(
      "flutter_naver_login",
      const StandardMethodCodec(),
      registrar,
    );
    final FlutterNaverLoginPlugin instance = FlutterNaverLoginPlugin();
    channel.setMethodCallHandler(instance.methodCallHandler);
  }

  Future<dynamic> methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "logIn":
        return _logIn();
      case "logOut":
        return _logOut();
      case "getCurrentAccount":
        return _getCurrentAccount();
      case "getCurrentAccessToken":
        return _getCurrentAccessToken();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "flutter_naver_login plugin for web does not support"
                    "the method '${call.method}' yet."
        );
    }
  }

  _logIn() {
    print("in _logIn");
    // init
    if (_clientId == null) {
      html.window.alert("네이버 아이디 로그인 Client ID가 필요합니다.");
      return;
    }
    if (_callbackUrl == null) {
      html.window.alert("네이버 아이디 로그인 callback Url이 필요합니다.");
      return;
    }
    var naverIdLogin = new naver_id_login(_clientId!, _callbackUrl!);
    var state = naverIdLogin.getUniqState();
    naverIdLogin.setDomain(html.window.location.hostname!);
    naverIdLogin.setState(state);
    naverIdLogin.init_naver_id_login();
  }

  _logOut() {
    print("in _logOut");
    const String logoutUrl = "http://nid.naver.com/nidlogin.logout?";
    var loginTab = html.window.open(logoutUrl, 'new tab');
    // do something
    loginTab.close();
  }

  _getCurrentAccount() {

  }

  _getCurrentAccessToken() {

  }
}