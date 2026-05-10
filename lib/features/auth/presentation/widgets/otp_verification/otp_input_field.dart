import 'package:wassaly/core/imports/imports.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.autoFocus = true,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<String> _otpValues;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );
    _otpValues = List.generate(widget.length, (_) => '');

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      _otpValues[index] = value.substring(value.length - 1);
      _controllers[index].text = _otpValues[index];
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _otpValues[index].length),
      );

      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      _otpValues[index] = '';
    }

    final otp = _otpValues.join();
    widget.onChanged?.call(otp);

    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_otpValues[index].isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
          _otpValues[index - 1] = '';
          _controllers[index - 1].clear();
          widget.onChanged?.call(_otpValues.join());
        }
      }
    }
  }

  void clear() {
    for (var i = 0; i < widget.length; i++) {
      _otpValues[i] = '';
      _controllers[i].clear();
    }
    _focusNodes[0].requestFocus();
  }

  void setOtp(String otp) {
    if (otp.length != widget.length) return;

    for (var i = 0; i < widget.length; i++) {
      _otpValues[i] = otp[i];
      _controllers[i].text = otp[i];
    }
    _focusNodes.last.requestFocus();
    widget.onChanged?.call(otp);
    widget.onCompleted(otp);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SizedBox(
            width: 45.w,
            height: 50.h,
            child: Focus(
              onKeyEvent: (_, event) {
                _onKeyEvent(index, event);
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: context.theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: cs.primary,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) => _onChanged(index, value),
              ),
            ),
          ),
        );
      }),
    );
  }
}
