import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:pinput/pinput.dart';

class PinPutOtpWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;
  final Function(String) onChanged;
  final int length;
  final bool isDisabled;

  const PinPutOtpWidget({
    super.key,
    required this.controller,
    required this.onCompleted,
    required this.onChanged,
    this.length = 6,
    this.isDisabled = false,
  });

  @override
  _PinPutOtpWidgetState createState() => _PinPutOtpWidgetState();
}

class _PinPutOtpWidgetState extends State<PinPutOtpWidget> {
  late bool isDisable;

  @override
  void initState() {
    super.initState();
    isDisable = widget.isDisabled;
  }

  @override
  Widget build(BuildContext context) {
    Color focusedBorderColor = AppColor.redPrimary;

    PinTheme defaultPinTheme = PinTheme(
      width: 65,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: AppColor.textWhite,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.white.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: widget.length,
        controller: widget.controller,
        defaultPinTheme: defaultPinTheme,
        validator: (value) => null,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {
          setState(() {
            isDisable = true;
          });
          widget.onCompleted(pin);
        },
        onChanged: (value) {
          setState(() {
            isDisable = value.length == widget.length;
          });
          widget.onChanged(value);
        },
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              width: 22,
              height: 1,
              color: focusedBorderColor,
            ),
          ],
        ),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: focusedBorderColor),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: focusedBorderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }
}
