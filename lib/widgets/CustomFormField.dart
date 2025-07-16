import 'package:flutter/material.dart';
import './IconButton.dart';

class CustomFormField extends StatelessWidget {
  final bool isFilled;
  final bool isDense;
  final Color fillColor;
  final String? hintText;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final VoidCallback? onTap;
  final VoidCallback? prefixOnTap;
  final VoidCallback? suffixOnTap;
  final bool readOnly;
  final bool hasSuffix;
  final bool hasPrefix;
  final TextEditingController? textEditingController;
  final TextAlignVertical? textAlignVertical;
  final bool hasTextLabel;
  final String? label;
  final IconData? prefixIcon;
  final IconData? sufixIcon;
  final Color? iconColor;
  final double? iconSize;
  final bool hasIcon;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  const CustomFormField({
    super.key,
    this.isFilled = false,
    this.isDense = false,
    this.fillColor = Colors.white,
    this.hintText,
    this.borderRadius,
    this.borderSide,
    this.onTap,
    this.prefixOnTap,
    this.suffixOnTap,
    this.readOnly = false,
    this.hasSuffix = false,
    this.hasPrefix = false,
    this.textEditingController,
    this.textAlignVertical,
    this.hasTextLabel = false,
    this.label,
    this.prefixIcon,
    this.sufixIcon,
    this.iconColor,
    this.iconSize = 12,
    this.hasIcon = false,
    this.icon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      readOnly: readOnly,
      onTap: onTap ?? () {},
      textAlignVertical: textAlignVertical,
      decoration: InputDecoration(
        labelText: hasTextLabel ? label : null,
        hintText: hintText,
        filled: isFilled,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
          borderSide: borderSide ?? BorderSide.none,
        ),
        prefixIcon: hasPrefix
            ? CustomIconButton(
                onPressed: prefixOnTap ?? () {},
                icon: prefixIcon ?? Icons.error, 
                iconSize: iconSize ?? 12,
                iconColor: iconColor ?? Colors.grey, 
              )
            : null,
        suffixIcon: hasSuffix
            ? CustomIconButton(
                onPressed: suffixOnTap ?? () {},
                icon: sufixIcon ?? Icons.error, 
                iconSize: iconSize ?? 12,
                iconColor: iconColor ?? Colors.grey, 
              )
            : null,
        isDense: isDense,
        icon: hasIcon ? Icon(icon, size: iconSize, color: iconColor) : null,
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
