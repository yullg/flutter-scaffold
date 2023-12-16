import 'package:flutter/material.dart';

class EasyListTile extends StatelessWidget {
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? name;
  final String? nameText;
  final Widget? value;
  final String? valueText;
  final Widget? description;
  final String? descriptionText;
  final Widget? trailing;
  final IconData? trailingIcon;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const EasyListTile({
    super.key,
    this.leading,
    this.leadingIcon,
    this.name,
    this.nameText,
    this.value,
    this.valueText,
    this.description,
    this.descriptionText,
    this.trailing,
    this.trailingIcon,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final leadingWidget = leading ?? (leadingIcon != null ? Icon(leadingIcon!) : null);
    final nameWidget = name ?? (nameText != null ? Text(nameText!) : null);
    final valueWidget = value ??
        (valueText != null
            ? Text(
                valueText!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null);
    final descriptionWidget = description ?? (descriptionText != null ? Text(descriptionText!) : null);
    final trailingWidget = trailing ??
        (trailingIcon != null
            ? Icon(
                trailingIcon!,
                color: Theme.of(context).colorScheme.outline,
              )
            : null);
    return ListTile(
      leading: leadingWidget,
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (nameWidget != null) nameWidget,
          if (valueWidget != null) valueWidget,
        ],
      ),
      subtitle: descriptionWidget,
      trailing: trailingWidget,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
