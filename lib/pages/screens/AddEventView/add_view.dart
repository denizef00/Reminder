import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/providers/event_provider.dart';

class AddView extends ConsumerStatefulWidget {
  const AddView({super.key});

  @override
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
      resizeToAvoidBottomInset: true,
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
                padding: const EdgeInsets.only(top: 10.0),
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
                    final fullTime = DateTime.now();
                    final dateNow = DateFormat("dd/MM/yyyy").format(fullTime);
                    final timeNow = DateFormat("HH:mm").format(fullTime);
                    final allText = _textController.text.trim();
                    if (allText.isNotEmpty) {
                      _infoCard(
                        context,
                        name: allText,
                        desciptiom: 'Gemini Analyze Here',
                        date: dateNow,
                        time: timeNow,
                      );
                      _textController.clear();
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

  void _infoCard(
    BuildContext context, {
    required String name,
    required String desciptiom,
    required String date,
    required String time,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: Colors.transparent,
          elevation: 8,
          content: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Event Preview",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Event Name : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            'Event Description : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            desciptiom,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            'Event Date : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            "Event Time : ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  minimumSize: Size(50, 50),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      24,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_note_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Edit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  minimumSize: Size(50, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      24,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  ref
                                      .read(eventListProvider.notifier)
                                      .addEvent(name, desciptiom, date, time);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Event succesfully editted in your list!!',
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Accept",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
