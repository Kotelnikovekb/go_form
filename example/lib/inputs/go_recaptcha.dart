import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoRecaptcha extends FormFieldModelBase<String> {
  const GoRecaptcha({
    required super.name,
  });

  @override
  void onInit(FieldController<String> controller) async {
    print('start');
    if (controller.value == null) {
      final token = await RecaptchaService.getToken(
          '6LeTjmArAAAAAHe-oUr7j6kzlIVwgjDY033tC1J7');
      if (token != null) {
        controller.setValue(token);
      } else {
        controller.setError("Не удалось пройти проверку reCAPTCHA");
      }
    }
    super.onInit(controller);
  }

  @override
  Widget build(BuildContext context, FieldController<String> controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox.shrink(),
        if (controller.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class RecaptchaService {
  static Future<String?> getToken(String siteKey) async {
    final controller = WebViewController();
    final completer = Completer<String?>();

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.addJavaScriptChannel(
      'Captcha',
      onMessageReceived: (message) {
        completer.complete(message.message);
      },
    );

    final html = '''
      <!DOCTYPE html><html><head>
      <script src="https://www.google.com/recaptcha/api.js?render=$siteKey"></script>
      <script>
      function executeRecaptcha() {
        grecaptcha.ready(function() {
          grecaptcha.execute('$siteKey', {action: 'login'}).then(function(token) {
            Captcha.postMessage(token);
          });
        });
      }
      </script>
      </head><body onload="executeRecaptcha()"></body></html>
    ''';

    final encodedHtml =
        Uri.dataFromString(html, mimeType: 'text/html').toString();
    await controller.loadRequest(Uri.parse(encodedHtml));

    return completer.future
        .timeout(const Duration(seconds: 5), onTimeout: () => null);
  }
}
