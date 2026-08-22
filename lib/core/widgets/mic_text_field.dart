import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

/// A TextField with a mic icon that converts voice to text.
/// Supports Hindi, Marathi, and English via the device's speech engine.
class MicTextField extends StatefulWidget {
  const MicTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.maxLines = 1,
    this.keyboardType,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.locale,
    this.showMic = true,
  });

  final TextEditingController controller;
  final InputDecoration? decoration;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? locale;
  final bool showMic;

  @override
  State<MicTextField> createState() => _MicTextFieldState();
}

class _MicTextFieldState extends State<MicTextField> {
  static final SpeechToText _speech = SpeechToText();
  static bool _speechInited = false;
  bool _listening = false;

  Future<void> _toggleListen() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }

    if (!_speechInited) {
      _speechInited = await _speech.initialize(
        onError: (_) {
          if (mounted) setState(() => _listening = false);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _listening = false);
          }
        },
      );
    }

    if (!_speechInited) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
      return;
    }

    setState(() => _listening = true);

    final localeId = widget.locale ?? _defaultLocale;
    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        final text = result.recognizedWords;
        if (text.isEmpty) return;
        final existing = widget.controller.text;
        if (existing.isNotEmpty && !existing.endsWith(' ')) {
          widget.controller.text = '$existing $text';
        } else {
          widget.controller.text = '$existing$text';
        }
        widget.controller.selection = TextSelection.collapsed(
          offset: widget.controller.text.length,
        );
      },
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  String get _defaultLocale {
    final loc = Localizations.localeOf(context);
    if (loc.languageCode == 'hi') return 'hi_IN';
    if (loc.languageCode == 'mr') return 'mr_IN';
    return 'en_IN';
  }

  @override
  void dispose() {
    if (_listening) _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseDeco = widget.decoration ?? const InputDecoration();

    final micButton = widget.showMic && widget.enabled
        ? IconButton(
            icon: Icon(
              _listening ? Icons.mic : Icons.mic_none,
              color: _listening ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
            tooltip: _listening ? 'Stop' : 'Speak',
            onPressed: _toggleListen,
          )
        : null;

    final deco = baseDeco.copyWith(
      suffixIcon: micButton != null
          ? (baseDeco.suffixIcon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [baseDeco.suffixIcon!, micButton],
                )
              : micButton)
          : baseDeco.suffixIcon,
    );

    return TextField(
      controller: widget.controller,
      decoration: deco,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
    );
  }
}
