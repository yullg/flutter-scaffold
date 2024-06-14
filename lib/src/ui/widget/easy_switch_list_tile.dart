import 'package:flutter/material.dart';

import 'easy_list_tile.dart';

class EasySwitchListTile extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final Widget? secondary;
  final IconData? secondaryIcon;
  final bool? value;
  final Widget? valuePlaceholder;
  final String? valuePlaceholderText;
  final ValueChanged<bool>? onChanged;

  const EasySwitchListTile({
    super.key,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.secondary,
    this.secondaryIcon,
    required this.value,
    this.valuePlaceholder,
    this.valuePlaceholderText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      return SwitchListTile(
        value: value!,
        onChanged: onChanged,
        title: title ?? (titleText != null ? Text(titleText!) : null),
        subtitle: subtitle ?? (subtitleText != null ? Text(subtitleText!) : null),
        secondary: secondary ?? (secondaryIcon != null ? Icon(secondaryIcon) : null),
      );
    } else {
      return EasyListTile(
        leading: secondary,
        leadingIcon: secondaryIcon,
        name: title,
        nameText: titleText,
        value: valuePlaceholder,
        valueText: valuePlaceholderText,
        description: subtitle,
        descriptionText: subtitleText,
        onTap: () {
          onChanged?.call(true);
        },
      );
    }
  }
}
