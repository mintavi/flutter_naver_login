// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html' as html;

/// Injects a list of JS [libraries] as `script` tags into a [target] [html.HtmlElement].
///
/// If [target] is not provided, it defaults to the web app's `head` tag (see `web/index.html`).
/// [libraries] is a list of URLs that are used as the `src` attribute of `script` tags
/// to which an `onLoad` listener is attached (one per URL).
///
/// Returns a [Future] that resolves when all of the `script` tags `onLoad` events trigger.
Future<void> injectJSLibraries(
  List<String> libraries, {
  html.HtmlElement? target,
}) {
  final List<Future<void>> loading = <Future<void>>[];
  final List<html.HtmlElement> tags = <html.HtmlElement>[];

  final html.Element targetElement = target ?? html.querySelector('body')!;

  libraries.forEach((String library) {
    final html.ScriptElement script = html.ScriptElement()
      ..async = true
      ..defer = true
      ..src = library;
    // TODO add a timeout race to fail this future
    loading.add(script.onLoad.first);
    tags.add(script);
  });

  targetElement.children.addAll(tags);
  return Future.wait(loading);
}

// Future<void> injectJSText(String jsText, {html.HtmlElement? target,}) {
//   final html.Element targetElement = target ?? html.querySelector('head')!;

//   final html.ScriptElement script = html.ScriptElement()
//     ..async = true
//     ..defer = true
//     ..innerHtml = jsText;

//   final Future<void> loading = script.onLoad.first;

//   targetElement.children.add(script);
//   return loading;
// }