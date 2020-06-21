import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showShort(String text) => _show(text, Toast.LENGTH_SHORT);

  static void showLong(String text) => _show(text, Toast.LENGTH_LONG);

  static void _show(String text, Toast toastLength) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: text, toastLength: toastLength);
  }

  ToastHelper._();
}
