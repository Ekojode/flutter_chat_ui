import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';

/// A class that represents attachment button widget.
class AttachmentButton extends StatelessWidget {
  /// Creates attachment button widget.
  const AttachmentButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  /// Show a loading indicator instead of the button.
  final bool isLoading;

  /// Callback for attachment button tap event.
  final VoidCallback? onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        margin: InheritedChatTheme.of(context).theme.attachmentButtonMargin ??
            const EdgeInsetsDirectional.fromSTEB(
              8,
              0,
              0,
              0,
            ),
        child: IconButton(
          constraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          icon: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      InheritedChatTheme.of(context).theme.inputTextColor,
                    ),
                  ),
                )
              : InheritedChatTheme.of(context).theme.attachmentButtonIcon ??
                  Image.asset(
                    'assets/icon-attachment.png',
                    color: InheritedChatTheme.of(context).theme.inputTextColor,
                    package: 'flutter_chat_ui',
                  ),
          onPressed: isLoading ? null : onPressed,
          padding: padding,
          splashRadius: 24,
          tooltip:
              InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
        ),
      );
}

class TextEmojiPicker extends StatefulWidget {
  final TextEditingController controller;
  const TextEmojiPicker({super.key, required this.controller});

  @override
  State<TextEmojiPicker> createState() => _TextEmojiPickerState();
}

class _TextEmojiPickerState extends State<TextEmojiPicker> {
  bool emojiShowing = false;

  void _onBackspacePressed() {
    widget.controller
      ..text = widget.controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            margin:
                InheritedChatTheme.of(context).theme.attachmentButtonMargin ??
                    const EdgeInsetsDirectional.fromSTEB(
                      8,
                      0,
                      0,
                      0,
                    ),
            child: IconButton(
              constraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 24,
              ),
              icon: const Icon(
                Icons.emoji_emotions,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  emojiShowing = !emojiShowing;
                });
              },
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: widget.controller,
                onBackspacePressed: _onBackspacePressed,
                config: Config(
                  columns: 7,
                  // Issue: https://github.com/flutter/flutter/issues/28894.
                  emojiSizeMax: 32 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.30
                          : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: const Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  recentTabBehavior: RecentTabBehavior.RECENT,
                  recentsLimit: 28,
                  replaceEmojiOnLimitExceed: false,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator: const SizedBox.shrink(),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                  checkPlatformCompatibility: true,
                ),
              ),
            ),
          ),
        ],
      );
}
