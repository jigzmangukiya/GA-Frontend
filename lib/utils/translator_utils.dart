import 'package:flutter/cupertino.dart';
import 'package:translator/translator.dart';

class TranslatorUtils {
  final translator = GoogleTranslator();

  Future<String> translateText(String text, {String toLanguage = 'en'}) async {
    Translation translation = await translator.translate(text, to: toLanguage);
    return translation.text;
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle txtstyle;
  const TextWidget({super.key, required this.text, required this.txtstyle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: TranslatorUtils().translateText(text, toLanguage: "en"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: txtstyle,
            textAlign: TextAlign.center,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: txtstyle);
        } else {
          return CupertinoActivityIndicator();
        }
      },
    );
  }
}
