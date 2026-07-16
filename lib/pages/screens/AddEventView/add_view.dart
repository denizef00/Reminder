import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/pages/widgets/info_cardview.dart';
import 'package:reminder/providers/gemini_provider.dart';
import 'package:uuid/uuid.dart';

class AddView extends ConsumerStatefulWidget {
  const AddView({super.key});

  @override
  ConsumerState<AddView> createState() => _AddViewState();
}

class _AddViewState extends ConsumerState<AddView> {
  final TextEditingController _textController = TextEditingController();

  get uuid => Uuid();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isGeminiLoading = ref.watch(geminiLoadingProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isGeminiLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Gemini Analyze Your Text",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      ref
                          .read(geminiLoadingProvider.notifier)
                          .cancelOperation();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Operation canceled by user!'),
                          backgroundColor: Theme.of(context).colorScheme.error,

                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 114,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: 9,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),

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
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              print("BUTONA BASTIN");
                              final String userText = _textController.text
                                  .trim();

                              if (userText.isNotEmpty) {
                                String id = uuid.v4();

                                InfoCard.show(
                                  context,
                                  ref,
                                  id: id,
                                  name: userText,
                                  description: "description",
                                  date:
                                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                  time:
                                      "${DateTime.now().hour}:${DateTime.now().minute}",
                                  onCheckPressed: () {},
                                  onDeletePressed: () {},
                                  onConfirm: () {},
                                  buttonName1: "Cancel",
                                  buttonName2: "Accept",
                                  edittingMode: false,
                                );
                              }
                              /*
                              if (userText.isNotEmpty) {
                                ref
                                    .read(geminiLoadingProvider.notifier)
                                    .setLoading(true);

                                final geminiService = ref.read(
                                  geminiServiceProvider,
                                );
                                final Map<String, dynamic>? eventData =
                                    await geminiService.parseTexttoEvent(
                                      userText,
                                    );

                                ref
                                    .read(geminiLoadingProvider.notifier)
                                    .setLoading(false);

                                if (eventData != null) {

                                  _infoCard(
                                    context,
                                    name: eventData['eventName'] ?? 'New Event',
                                    description:
                                        eventData['description'] ?? '--',
                                    date:
                                        eventData['date'] ??
                                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                    time:
                                        eventData['time'] ??
                                        '${DateTime.now().hour}:${DateTime.now().minute}',
                                    onConfrim: (name, desc, date, time) {
                                      ref
                                          .read(eventListProvider.notifier)
                                          .addEvent(name, desc, date, time);

                                      _textController.clear();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Event successfully added to calendar!!',
                                          backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Gemini could not parse the text.Please try again!!',
                                      ),
                                      backgroundColor:Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please write something!!"),
                                    backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                                  ),
                                );
                              }*/
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
              ),
            ),
    );
  }
}
