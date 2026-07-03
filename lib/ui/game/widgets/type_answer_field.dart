import 'package:flutter/material.dart';

class TypeAnswerField extends StatefulWidget {
  final void Function(String text) onSubmit;
  final bool isEnabled;
  final String label;
  final String hint;
  final String checkLabel;
  final VoidCallback? onHint;
  final String? hintAnimalName;
  final TextEditingController? controller;

  const TypeAnswerField({
    super.key,
    required this.onSubmit,
    required this.isEnabled,
    required this.label,
    required this.hint,
    required this.checkLabel,
    this.onHint,
    this.hintAnimalName,
    this.controller,
  });

  @override
  State<TypeAnswerField> createState() => _TypeAnswerFieldState();
}

class _TypeAnswerFieldState extends State<TypeAnswerField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
  }

  @override
  void didUpdateWidget(TypeAnswerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled && !oldWidget.isEnabled) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (!widget.isEnabled) return;
    widget.onSubmit(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              if (widget.onHint != null)
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: widget.onHint,
                ),
            ],
          ),
          if (widget.hintAnimalName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.hintAnimalName!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.isEnabled,
            textCapitalization: TextCapitalization.none,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.isEnabled ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, size: 28),
                const SizedBox(width: 8),
                Text(
                  widget.checkLabel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
