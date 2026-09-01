import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class EmojiPickerWidget extends StatelessWidget {
  final bool visible;
  final TextEditingController controller;

  const EmojiPickerWidget({
    super.key,
    required this.visible,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !visible,
      child: SizedBox(
        height: 300,
        child: EmojiPicker(
          textEditingController: controller,
          config: const Config(
            emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28),
            skinToneConfig: SkinToneConfig(
              dialogBackgroundColor: Color.fromARGB(162, 56, 1, 123),
            ),
            categoryViewConfig: CategoryViewConfig(),
          ),
        ),
      ),
    );
  }
}
