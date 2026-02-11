import 'package:flutter/material.dart';
import '../../theme/theme.dart';

enum BlaButtonType { primary, secondary }
enum BlaButtonIconPosition { leading, trailing }

class BlaButton extends StatelessWidget{
  final String text;
  final VoidCallback? onPressed;
  final BlaButtonType type;
  final IconData? icon;
  final BlaButtonIconPosition position;

  const BlaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = BlaButtonType.primary,
    this.icon,
    this.position = BlaButtonIconPosition.leading,
  });

    @override
  Widget build(BuildContext context) {
    final bool isEnable = onPressed != null;
    final bool isPrimary = type == BlaButtonType.primary;
    
    return SizedBox(
      height: 48,
      child: isPrimary ? _buildPrimaryButton(isEnable) : _buildSecondaryButton(isEnable),
    );
  }

  Widget _buildPrimaryButton(bool isEnable){
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        // use disabled color when button is not enabled
        backgroundColor: isEnable ? BlaColors.primary : BlaColors.disabled,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BlaSpacings.radius),
        ),
        elevation: 0,
      ),
      child: _buildButtonContent(Colors.white),
      );
  }

  Widget _buildSecondaryButton(bool isEnable){
    return OutlinedButton(
      onPressed: onPressed, 
      style: OutlinedButton.styleFrom(
        foregroundColor: isEnable ? BlaColors.primary : BlaColors.disabled,
        side: BorderSide(
          color: isEnable ? BlaColors.primary : BlaColors.disabled,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BlaSpacings.radius)
        )
      ),
    child: _buildButtonContent(isEnable ? BlaColors.primary : BlaColors.disabled),);
  }

  //shared content building for both primary and secondary button
  Widget _buildButtonContent(Color iconColor){
    //if there's no icon, then render the text only
    if(icon == null){
      return(Text(text, style: BlaTextStyles.button));
    }

    final iconWidget = Icon(icon, size: 20);
    final textWidget = Text(text, style: BlaTextStyles.button);

    //icon before text since position is leading
    if(position == BlaButtonIconPosition.leading){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          SizedBox(width: BlaSpacings.s),
          textWidget,
        ],
      );
    // icon after text since position is trailing
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget,
          SizedBox(width: BlaSpacings.s,),
          iconWidget,
        ],
      );
    }
  }
}