import 'package:flutter/material.dart';
import 'package:cat_motion/design/colors.dart';
import 'package:cat_motion/design/dimensions.dart';

class ProgressAccentButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final bool disabled;
  final Function() onTap;

  const ProgressAccentButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isLoading,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled ? null : onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          width200,
          height40,
        ),
        maximumSize: const Size.fromHeight(
          height40,
        ),
        backgroundColor: primaryColor,
        elevation: elevation0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        padding: const EdgeInsets.only(
          left: padding16,
          right: padding16,
        ),
      ),
      child: isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: surfaceColor,
                  fontSize: fontSize16,
                  fontWeight: FontWeight.w600),
            ),
    );
  }
}
