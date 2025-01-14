import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'web/inject_js_libraries.dart';
import 'web/naver_login.dart';

class FlutterNaverLoginPlugin {
  static late final String? _clientId;
  static late final String? _callbackUrl;

  static initialize() async {
    const String jQueryUrl = 'https://code.jquery.com/jquery-1.11.3.min.js';
    const String naverApiUrl = 'https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js';
    const String processCallbackUrl = 'assets/packages/flutter_naver_login/assets/process_callback.js';
    
    await injectJSLibraries([jQueryUrl, naverApiUrl, processCallbackUrl]);

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
      // case "getCurrentAccount":
      //   return _getCurrentAccount();
      // case "getCurrentAccessToken":
      //   return _getCurrentAccessToken();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "flutter_naver_login plugin for web does not support"
                    "the method '${call.method}' yet."
        );
    }
  }

  Future<Map<dynamic, dynamic>> _logIn() {
    // TODO: turn this into .js file and simplify java interop?
    var naverIdLogin = new naver_id_login(_clientId!, _callbackUrl!);
    var state = naverIdLogin.getUniqState();
    naverIdLogin.setDomain(".rftap.net");
    naverIdLogin.setState(state);

    Completer<Map<dynamic, dynamic>> result = new Completer<Map<dynamic, dynamic>>();


    String loginUrl = naverIdLogin.getNaverIdLoginLink();
    final html.WindowBase popup = html.window.open(loginUrl, '_blank');

    html.window.addEventListener("message", (e) {
      if (!result.isCompleted) {
        result.complete(
          (e as html.MessageEvent).data
        );
      } else {print("completer already completed!");}
    });
    
    return result.future;
  }

  Map<dynamic, dynamic> _logOut() {
    print("in _logOut");
    const String logoutUrl = "https://nid.naver.com/nidlogin.logout?";
    var logoutWindow = html.window.open(logoutUrl, 'new tab');
    logoutWindow.close();

    Map<dynamic, dynamic> result =
      {
          "status": "loggedIn",
      };
    return result;
  }

  _getCurrentAccount() {
    // var nil = new naver_id_login(_clientId!, _callbackUrl!);
    // var result =
    // {
    //     "status": "loggedIn",
    //     "accessToken": nil.getAccessToken(),
    //     "expiresAt": nil.oauthParams.expires_in,
    //     "tokenType": nil.oauthParams.token_type,
    //     "errorMessage": "",
    //     "age": nil.getProfileData("age"),
    //     "birthday": nil.getProfileData("birthday"),
    //     "email": nil.getProfileData("email"),
    //     "enc_id": nil.getProfileData("enc_id"),
    //     "gender": nil.getProfileData("gender"),
    //     "id": nil.getProfileData("id"),
    //     "nickname": nil.getProfileData("nickname"),
    //     "profile_image": nil.getProfileData("profile_image"),
    // };
    // return result;
  }

  _getCurrentAccessToken() {
    // var naverIdLogin = new naver_id_login(_clientId!, _callbackUrl!);
    // return naverIdLogin.getAccessToken();
  }
}