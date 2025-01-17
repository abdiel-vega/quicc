import 'package:flutter/material.dart';

/// A stateful widget that represents a page for flipping a coin.
class FlipACoinPage extends StatefulWidget {
  const FlipACoinPage({super.key});

  @override
  State<FlipACoinPage> createState() => _FlipACoinPageState();
}

class _FlipACoinPageState extends State<FlipACoinPage> {
  @override
  Widget build(BuildContext context) {
    // Placeholder for the widget's UI
    return Scaffold(
      backgroundColor: const Color(0xFF84DCC6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Height of the AppBar
        child: Material(
          elevation: 4.0, // Drop shadow elevation
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Rounds the bottom corners
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color(0xFFFF686B),
              elevation: 4.0,
              title: const Text(
                "Flip a Coin",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose a side",
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFFF686B),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9CA1),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(123, 0, 0, 0),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Heads",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9CA1),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(123, 0, 0, 0),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Tails",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Tap to flip coin!",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFF686B),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
