import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'web/inject_js_libraries.dart';
import 'web/naver_login.dart';

class FlutterNaverLoginPlugin {
  final String _clientId = "5olG0LvBwCIDpaaFXOZH";
  final String _callbackUrl = "www.naver.com";

  static initialize() async {
    const String naverApiUrl = 'https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js';
    const String jQueryUrl = 'http://code.jquery.com/jquery-1.11.3.min.js';
    await injectJSLibraries([naverApiUrl, jQueryUrl]);
  }

  static void registerWith(Registrar registrar) async {
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
    // init
    var naverIdLogin = new naver_id_login(_clientId, _callbackUrl);
    var state = naverIdLogin.getUniqState();
    naverIdLogin.setDomain("YOUR_SERVICE_URL");
    naverIdLogin.setState(state);
    naverIdLogin.setPopup(true);
    naverIdLogin.init_naver_id_login();
  }

  _logOut() {
    const String logoutUrl = "http://nid.naver.com/nidlogin.logout";
    html.window.open(logoutUrl, 'new tab');
    html.window.close();
  }

  _getCurrentAccount() {

  }

  _getCurrentAccessToken() {

  }
}