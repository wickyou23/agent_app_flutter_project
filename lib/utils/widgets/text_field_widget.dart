import 'package:agent_app/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPTextField extends StatelessWidget {
  const TPTextField({
    Key? key,
    this.controller,
    this.text,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textAlign,
    this.textStyle,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired,
    this.editable = true,
    this.autofocus = false,
    this.focusNode,
    this.maxLength,
    this.textCapitalization,
    this.onTap,
    this.readOnly = false,
    this.maxLine = 1,
    this.onChanged,
    this.textInputAction,
    this.toolbarOptions,
    this.onFieldSubmitted,
    this.selectionControls,
  }) : super(key: key);

  final String? hint;
  final String? text;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? isRequired;
  final bool editable;
  final bool autofocus;
  final FocusNode? focusNode;
  final int? maxLength;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLine;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ToolbarOptions? toolbarOptions;
  final Function(String)? onFieldSubmitted;
  final TextSelectionControls? selectionControls;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      enabled: editable,
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      style:
          textStyle ?? textTheme(context).body.copyWith(color: Colors.black87),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      maxLines: maxLine,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconConstraints:
            const BoxConstraints(minWidth: 44, maxHeight: 44),
        suffixIcon: suffixIcon,
        suffixIconConstraints:
            const BoxConstraints.expand(width: 44, height: 44),
        contentPadding: maxLine == 1
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        filled: true,
        fillColor: AppColors.whiteColor,
        errorStyle:
            textTheme(context).bodySmall2.copyWith(color: Colors.red[300]),
        hintText: hint,
        border: createBorder(),
        enabledBorder: createBorder(),
        focusedBorder: createBorder(),
        errorBorder: createBorder(borderColor: Colors.red[300]),
        disabledBorder: createBorder(borderColor: Colors.grey[300]),
        focusedErrorBorder: createBorder(),
        errorMaxLines: 2,
      ),
      keyboardType: keyboardType,
      textAlign: textAlign ?? TextAlign.left,
      autofocus: autofocus,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.done,
      toolbarOptions: toolbarOptions,
      onFieldSubmitted: onFieldSubmitted,
      selectionControls: selectionControls,
    );
  }

  InputBorder createBorder({Color? borderColor}) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(Dimens.cornerRadius),
      ),
      borderSide: BorderSide(
        color: borderColor ?? AppColors.primaryColor,
      ),
    );
  }
}

// PasswordTextField

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.title,
    this.text,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textAlign,
    this.textStyle,
    this.isRequired,
    this.textInputAction,
    this.toolbarOptions,
    this.editable,
    this.selectionControls,
  });
  final String? title;
  final String? hint;
  final String? text;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final bool? isRequired;
  final TextInputAction? textInputAction;
  final ToolbarOptions? toolbarOptions;
  final bool? editable;
  final TextSelectionControls? selectionControls;

  @override
  // ignore: library_private_types_in_public_api
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TPTextField(
      editable: widget.editable ?? true,
      controller: widget.controller,
      obscureText: obscureText,
      text: widget.text,
      hint: widget.hint,
      validator: widget.validator,
      suffixIcon: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 14, 10),
          child: obscureText
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        onTap: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
      ),
      isRequired: widget.isRequired,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      toolbarOptions: widget.toolbarOptions,
      selectionControls: widget.selectionControls,
    );
  }
}
