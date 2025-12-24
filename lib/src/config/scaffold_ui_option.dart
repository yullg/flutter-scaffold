import 'dart:ui';

class ScaffoldUiOption {
  final Color? popupLoadingBackgroundColor;
  final Color? popupLoadingForegroundColor;

  ScaffoldUiOption({this.popupLoadingBackgroundColor, this.popupLoadingForegroundColor});

  @override
  String toString() {
    return 'ScaffoldUiOption{popupLoadingBackgroundColor: $popupLoadingBackgroundColor, popupLoadingForegroundColor: $popupLoadingForegroundColor}';
  }
}
