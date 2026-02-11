import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BlaInputField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRequired;

  const BlaInputField({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    required this.onTap,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;

    return TextButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: BlaSpacings.s),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: hasValue ? BlaColors.primary : BlaColors.greyLight,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: hasValue ? BlaColors.primary : BlaColors.neutralLight,
            ),
            SizedBox(width: BlaSpacings.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.neutralLight,
                        ),
                      ),
                      if (isRequired)
                        Text(
                          ' *',
                          style: BlaTextStyles.label.copyWith(
                            color: BlaColors.primary,
                          ),
                        ),
                    ],
                  ),
                  if (hasValue) SizedBox(height: 4),
                  if (hasValue)
                    Text(
                      value!,
                      style: BlaTextStyles.body.copyWith(
                        color: BlaColors.textNormal,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}