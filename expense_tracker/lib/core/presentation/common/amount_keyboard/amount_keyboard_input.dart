import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// Input rules shared with amount [TextField]s in the app.
class AmountKeyboardInput {
  AmountKeyboardInput._();

  /// Same pattern used by amount fields via [FilteringTextInputFormatter].
  static final RegExp allowedPattern = RegExp(r'^\d+\.?\d*');

  /// Decimal separator used when parsing amounts ([double.parse]).
  static const String decimalSeparator = '.';

  static bool isAllowed(String text) {
    return text.isEmpty || allowedPattern.hasMatch(text);
  }

  static void insertCharacter({
    required TextEditingController controller,
    required String character,
  }) {
    final value = controller.value;
    final text = value.text;
    final selection = value.selection;

    final int start;
    final int end;
    if (selection.isValid && !selection.isCollapsed) {
      start = selection.start;
      end = selection.end;
    } else if (selection.isValid) {
      start = selection.start;
      end = selection.start;
    } else {
      start = text.length;
      end = text.length;
    }

    final newText = text.replaceRange(start, end, character);
    if (!isAllowed(newText)) return;

    final offset = start + character.length;
    controller.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  static void backspace(TextEditingController controller) {
    final value = controller.value;
    final text = value.text;
    final selection = value.selection;

    String newText;
    int offset;

    if (selection.isValid && !selection.isCollapsed) {
      newText = text.replaceRange(selection.start, selection.end, '');
      offset = selection.start;
    } else if (selection.isValid && selection.start > 0) {
      newText = text.replaceRange(selection.start - 1, selection.start, '');
      offset = selection.start - 1;
    } else if (text.isNotEmpty) {
      newText = text.substring(0, text.length - 1);
      offset = newText.length;
    } else {
      return;
    }

    if (!isAllowed(newText)) return;

    controller.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }
}
