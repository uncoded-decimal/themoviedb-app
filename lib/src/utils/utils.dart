import 'dart:io';

String getLocalSvg(String name) {
  return 'assets/svg/$name.svg';
}

Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup("google.co.in");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

String getLanguageName(String key) {
  switch (key) {
    case "en":
      return "English";
    case "es":
      return "Spanish";
    case "fr":
      return "French";
    case "ja":
      return "Japanese";
    case "hi":
      return "Hindi";
    case "pt":
      return "Portuguese";
    case "ko":
      return "Korean";
    case "it":
      return "Italian";
    case "ms":
      return "Malay";
    case "pl":
      return "Polish";
    case "uk":
      return "Ukrainian";
    default:
      return key;
  }
}
