import 'package:agent_app/res/res.dart';
import 'package:flutter/material.dart';

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.padding,
    this.enable = true,
    this.height = 40,
  }) : super(key: key);

  final String label;
  final EdgeInsets? padding;
  final T groupValue;
  final T value;
  final Function(T?) onChanged;
  final bool enable;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () {
        if (value != groupValue && enable) onChanged(value);
      },
      child: Container(
        height: height,
        padding: padding,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 20,
              child: Radio<T>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                focusColor: enable ? AppColors.primaryColor : Colors.grey,
                activeColor: enable ? AppColors.primaryColor : Colors.grey,
                groupValue: groupValue,
                value: value,
                onChanged: enable ? onChanged : null,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: isSelected
                  ? context.theme.textTheme.body.medium.copyWith(
                      color: enable ? Colors.black87 : Colors.grey,
                    )
                  : context.theme.textTheme.body.copyWith(
                      color: enable ? Colors.black87 : Colors.grey,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
