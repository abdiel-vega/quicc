import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'game_selection_page.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF84DCC6),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _showCustomDialog(context);
          },
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(width: 5.0, color: const Color(0xFFFFA69E)),
              color: const Color(0xFFFF686B),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(123, 0, 0, 0),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                )
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              "Let's Decide!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: MediaQuery.of(context)
                    .viewInsets, // Adjust padding dynamically
                child: SingleChildScrollView(
                  // Ensures the content is scrollable
                  child: Center(
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF686B),
                        border: Border.all(
                            width: 5.0, color: const Color(0xFFFFA69E)),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(123, 0, 0, 0),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: titleController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter Decision Title",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              filled: true,
                              fillColor: const Color(0xFFFF9CA1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: descriptionController,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Enter Description",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              filled: true,
                              fillColor: const Color(0xFFFF9CA1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9CA1),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            const Color.fromARGB(62, 0, 0, 0),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Back",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 5,
                                child: GestureDetector(
                                  onTap: () async {
                                    final title = titleController.text.trim();
                                    final description =
                                        descriptionController.text.trim();

                                    if (title.isNotEmpty &&
                                        description.isNotEmpty) {
                                      await _saveDecision(title, description);

                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const GameSelectionPage(),
                                        ));
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9CA1),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(62, 0, 0, 0),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Pick the Game ➔",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _saveDecision(String title, String description) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing decisions
    final String? decisionsJson = prefs.getString('decisions');
    List<Map<String, String>> decisions = [];
    if (decisionsJson != null) {
      decisions = List<Map<String, String>>.from(json.decode(decisionsJson));
    }

    // Add the new decision
    decisions.add({
      'title': title,
      'description': description,
    });

    // Save back to SharedPreferences
    await prefs.setString('decisions', json.encode(decisions));
  }
}
