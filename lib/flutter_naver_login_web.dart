import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'web/inject_js_libraries.dart';
import 'web/naver_login.dart';

class FlutterNaverLoginPlugin {
  static late final String? _clientId;
  static late final String? _callbackUrl;

  static initialize() async {
    const String jQueryUrl = 'http://code.jquery.com/jquery-1.11.3.min.js';
    const String naverApiUrl = 'https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js';
        
    await injectJSLibraries([jQueryUrl, naverApiUrl]);

    _clientId = html.window.document.querySelector("meta[name='naver-login-client-id']")
                    ?.getAttribute("content");
    _callbackUrl = html.window.document.querySelector("meta[name='naver-login-callback-url']")
                    ?.getAttribute("content");
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

  Future<dynamic> _logIn() {
    // TODO: turn this into .js file and simplify java interop?
    var naverIdLogin = new naver_id_login(_clientId!, _callbackUrl!);
    var state = naverIdLogin.getUniqState();
    naverIdLogin.setDomain(html.window.location.href);
    naverIdLogin.setState(state);

    String loginUrl = naverIdLogin.getNaverIdLoginLink();


    Completer<Map<dynamic, dynamic>> result = new Completer<Map<dynamic, dynamic>>();

    final html.WindowBase popup = html.window.open(
        loginUrl, 'naverloginpop', 'titlebar=1, resizable=1, scrollbars=yes, width=600, height=550');

    html.window.addEventListener("message", (e) {
      result.complete(
        (e as html.MessageEvent).data
      );
    });
    
    return result.future;
  }

  _logOut() {
    print("in _logOut");
    // const String logoutUrl = "http://nid.naver.com/nidlogin.logout?";
    // var logoutWindow = html.window.open(logoutUrl, 'new tab');
    // logoutWindow.close();
  }

  _getCurrentAccount() {
    var nil = new naver_id_login(_clientId!, _callbackUrl!);
    var result =
    {
        "status": "loggedIn",
        "accessToken": nil.getAccessToken(),
        "expiresAt": nil.oauthParams.expires_in,
        "tokenType": nil.oauthParams.token_type,
        "errorMessage": "",
        "age": nil.getProfileData("age"),
        "birthday": nil.getProfileData("birthday"),
        "email": nil.getProfileData("email"),
        "enc_id": nil.getProfileData("enc_id"),
        "gender": nil.getProfileData("gender"),
        "id": nil.getProfileData("id"),
        "nickname": nil.getProfileData("nickname"),
        "profile_image": nil.getProfileData("profile_image"),
    };
    return result;
  }

  _getCurrentAccessToken() {
    var naverIdLogin = new naver_id_login(_clientId!, _callbackUrl!);
    return naverIdLogin.getAccessToken();
  }
}