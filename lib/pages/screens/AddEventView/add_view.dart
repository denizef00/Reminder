import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder/providers/event_provider.dart';

class AddView extends ConsumerStatefulWidget {
  const AddView({super.key});

  ConsumerState<AddView> createState() => _AddViewState();
}

class _AddViewState extends ConsumerState<AddView> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 114),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 10,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),

                    hintText: "There's a meeting tomorrow at 8:40.",
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiary.withOpacity(0.5),
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    print("BUTONA BASTIN");
                    final enteredText = _textController.text.trim();

                    if (enteredText.isNotEmpty) {
                      ref
                          .read(eventListProvider.notifier)
                          .addEvent(
                            enteredText,
                            'Gemini will analyze',
                            '30.06.2026',
                            '8:40',
                          );

                      _textController.clear();

                      if (context.mounted) {
                        //Navigator.of(context, rootNavigator: true).pop();
                        context.pop();
                      }
                    } else {
                      print("HATA");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please write something!"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "ADD EVENT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
