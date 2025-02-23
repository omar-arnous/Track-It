import 'package:flutter/material.dart';

enum Type { text, password, email, number, textarea }

class FormInput extends StatefulWidget {
  bool secure;
  final bool focus;
  final bool require;
  final String? label;
  final String hint;
  final Type type;
  final Widget? leading;
  final Widget? trailing;
  final TextEditingController controller;

  FormInput({
    super.key,
    this.secure = false,
    this.focus = false,
    this.type = Type.text,
    this.hint = '',
    this.require = false,
    this.leading,
    this.trailing,
    required this.controller,
    required this.label,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == Type.text) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.secure,
              autofocus: widget.focus,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty && widget.require
                  ? '${widget.label} is required'
                  : null,
              decoration: InputDecoration(
                hintText: widget.hint,
                prefix: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures it takes only the necessary space
                  children: [
                    widget.leading ?? const SizedBox(), // Leading text
                    const SizedBox(
                        width: 10), // Space between leading and input
                  ],
                ),
                suffix: widget.trailing,
              ),
            ),
          ],
        ),
      );
    } else if (widget.type == Type.email) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.secure,
              autofocus: widget.focus,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val!.isEmpty && widget.require) {
                  return 'Email address is required';
                } else if (!val.contains('@') || !val.contains('.')) {
                  return 'Invalid email address';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: widget.hint,
                prefix: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures it takes only the necessary space
                  children: [
                    widget.leading ?? const SizedBox(), // Leading text
                    const SizedBox(
                        width: 10), // Space between leading and input
                  ],
                ),
                suffix: widget.trailing,
              ),
            ),
          ],
        ),
      );
    } else if (widget.type == Type.password) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.secure,
              autofocus: widget.focus,
              keyboardType: TextInputType.visiblePassword,
              validator: (val) {
                if (val!.isEmpty && widget.require) {
                  return 'Password is required';
                } else if (val.length < 8) {
                  return 'Password must be min 8 charecters length';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: widget.hint,
                prefix: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures it takes only the necessary space
                  children: [
                    widget.leading ?? const SizedBox(), // Leading text
                    const SizedBox(
                        width: 10), // Space between leading and input
                  ],
                ),
                suffix: widget.trailing,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.secure = !widget.secure;
                    });
                  },
                  icon: widget.secure
                      ? const Icon(Icons.visibility_rounded)
                      : const Icon(Icons.visibility_off_rounded),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.type == Type.number) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.secure,
              autofocus: widget.focus,
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty && widget.require
                  ? '${widget.label} is required'
                  : null,
              decoration: InputDecoration(
                prefix: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures it takes only the necessary space
                  children: [
                    widget.leading ?? const SizedBox(), // Leading text
                    const SizedBox(
                        width: 10), // Space between leading and input
                  ],
                ),
                suffix: widget.trailing,
              ),
            ),
          ],
        ),
      );
    } else if (widget.type == Type.textarea) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.secure,
              autofocus: widget.focus,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty && widget.require
                  ? '${widget.label} is required'
                  : null,
              maxLines: 3,
              minLines: 3,
              decoration: InputDecoration(
                prefix: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures it takes only the necessary space
                  children: [
                    widget.leading ?? const SizedBox(), // Leading text
                    const SizedBox(
                        width: 10), // Space between leading and input
                  ],
                ),
                suffix: widget.trailing,
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text('');
    }
  }
}
