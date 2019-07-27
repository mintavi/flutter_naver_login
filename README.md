# flutter_naver_login
[![Build Status](https://img.shields.io/badge/pub-v0.3.2-success.svg)](https://travis-ci.org/roughike/flutter_naver_login)
[![Build Status](https://img.shields.io/badge/pod-v1.6.1-success.svg)](https://travis-ci.org/roughike/flutter_naver_login)
[![Build Status](https://img.shields.io/badge/ios-10.0-success.svg)](https://travis-ci.org/roughike/flutter_naver_login)
[![Build Status](https://img.shields.io/badge/naverSDK-v4.0.12-success.svg)](https://travis-ci.org/roughike/flutter_naver_login)
[![Build Status](https://img.shields.io/badge/build-passing-success.svg)](https://travis-ci.org/roughike/flutter_naver_login)

A Flutter plugin for using the native Naver Login SDKs on Android and iOS.

## AndroidX support

- for [AndroidX Flutter projects](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)

## Installation

To get things up and running, you'll have to declare a pubspec dependency in your Flutter project.
Also some minimal Android & iOS specific configuration must be done, otherise your app will crash.

### On your Flutter project

See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_naver_login#-installing-tab-).

### Android

This assume that you have performed the "link app to package name and base class [the Naver Login documentation for Android site](https://developers.naver.com/docs/login/android/).

Your Application Info is shown in the for Naver Developer Website.

Then find out what the Client ID is. The Naver Client ID can be found on the Naver App Dashboard from the Naver Developer Console.

Once you find out your Naver Client ID, URL Scheme and Set Package Name  you'll have to do some things.

Then simply copy and paste into _ROOT_.

**\<your project root>android/app/src/main/res/values/strings.xml**

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="client_id">[client_id]</string>
    <string name="client_secret">[client_secret]</string>
    <string name="client_name">[client_name]</string>
</resources>
```

**\<your project root>android/app/src/main/AndroidManifest.xml**

```xml
 <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="flutter_naver_login_example"
        android:icon="@mipmap/ic_launcher">
        <meta-data
            android:name="com.naver.sdk.clientId"
            android:value="@string/client_id" />
        <meta-data
            android:name="com.naver.sdk.clientSecret"
            android:value="@string/client_secret" />
         <meta-data
            android:name="com.naver.sdk.clientName"
            android:value="@string/client_name" />
			...
```


A sample of the file can be found here. [here](https://github.com/yoonjaepark/flutter_naver_login/blob/master/example/android/app/src/main/AndroidManifest.xml).

Done!

### iOS
[Cocoapod](https://cocoapods.org/)

**\<your project root>ios/**

```bash
pod install
```

This assumes that you've done the _"Register and Configure Your App with Naver"_ step in the
[the Naver Login documentation for iOS site](https://developers.naver.com/docs/login/ios/).
(**Note**: you can skip "Step 2: Set up Your Development Environment").

After you've done that, find out what your Naver App Client ID is. You can find your Client ID, Client Secret, URL_SCHEME, in your Naver App's dashboard in the Naver developer.

**\<your project root>ios/Runner/Info.plist**
```xml
    <key>LSApplicationQueriesSchemes</key>
   <array>
      <string>naversearchapp</string>
      <string>naversearchthirdlogin</string>
   </array>

	<key>kServiceAppUrlScheme</key>
	<string>[UrlScheme]</string>
	<key>kConsumerKey</key>
	<string>[ConsumerKey]</string>
	<key>kConsumerSecret</key>
	<string>[ConsumerSecret]</string>
	<key>kServiceAppName</key>
	<string>[ServiceAppName]</string>


   <key>NSAppTransportSecurity</key>
   <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
      <key>NSExceptionDomains</key>
      <dict>
         <key>naver.com</key>
         <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSIncludesSubdomains</key>
            <true/>
         </dict>
         <key>naver.net</key>
         <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSIncludesSubdomains</key>
            <true/>
         </dict>
      </dict>
   </dict>
```
A sample of a complete Info.plist file can be found [here](https://github.com/yoonjaepark/flutter_naver_login/blob/master/example/ios/Runner/Info.plist).

Done!

## How do I use it?

The library tries to closely match the native Android & iOS login SDK APIs where possible. For complete API documentation, just see the [source code](). Everything is documented there.

Since sample code is worth more than one page of documentation, here are the usual cases covered:

### Getting the Naver acccount of a signed in user

```dart
NaverLoginResult res = await FlutterNaverLogin.logIn();
setState(() {
    name = res.account.name;
});
```

The `account` variable will now contain the following information:

```dart
final String nickname;
final String id;
final String name;
final String email;
final String gender;
final String age;
final String birthday;
final String profileImage;
```

### Getting the Naver currentAccessToken of a signed in user

```dart
import 'package:flutter_naver_login/flutter_naver_login.dart';

NaverLoginResult res = await FlutterNaverLogin.logIn();
final NaverLoginResult result = await FlutterNaverLogin.logIn();
NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
setState(() {
   accesToken = res.accessToken;
   tokenType = res.tokenType;
});
```


### ios issue 
1. Naver App login disable
1. CocoaPods could not find compatible versions for pod "naveridlogin-sdk-ios" Specs satisfying the `naveridlogin-sdk-ios (~> 4.0.12)` dependency were found, but they required a higher minimum deployment target.
    - runner target - required a higher deployment target 10.0.
1. d: warning: directory not found for option '-L/project directory'
ld: library not found for -lflutter_naver_login
clang: error: linker command failed with exit code 1 (use -v to see invocation)
    - build - clean - commandRun: flutter run
1. Showing All Messages: Multiple commands produce '/Users/yoonjaepark/dev/my_app/build/ios/Debug-iphonesimulator/Runner.app/Frameworks/Flutter.framework': 
    - file - project settings - build system - legacy build system
