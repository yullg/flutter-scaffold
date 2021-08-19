import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultErrorView extends StatelessWidget {
  final String title;
  final String? summary;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  DefaultErrorView({Key? key, required this.title, this.summary, this.buttonText, this.onButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 46.sp)),
          if (summary != null) Text(summary!, style: TextStyle(fontSize: 40.sp, color: Colors.grey)),
          SizedBox(width: double.infinity, height: 10),
          if (buttonText != null)
            ElevatedButton(
                child: Text(buttonText!),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 46.sp)),
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(25, 0, 25, 0)),
                ),
                onPressed: onButtonPressed)
        ],
      );
}
