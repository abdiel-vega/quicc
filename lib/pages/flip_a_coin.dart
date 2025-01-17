import 'dart:math';
import 'package:flutter/material.dart';

class FlipACoinPage extends StatefulWidget {
  const FlipACoinPage({super.key});

  @override
  State<FlipACoinPage> createState() => _FlipACoinPageState();
}

class _FlipACoinPageState extends State<FlipACoinPage>
    with SingleTickerProviderStateMixin {
  String? _selectedSide; // User's choice (Heads or Tails)
  String _result = ""; // Result of the coin flip
  bool _isFlipping = false; // Flag to disable buttons while flipping
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the flip animation
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _determineResult();
        }
      });

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_selectedSide == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Heads or Tails!")),
      );
      return;
    }

    setState(() {
      _isFlipping = true; // Disable buttons during animation
    });
    _controller.forward();
  }

  void _determineResult() {
    final isHeads = Random().nextBool(); // Randomly determine heads or tails
    final flipResult = isHeads ? "Heads" : "Tails";

    setState(() {
      _result = flipResult;
      _isFlipping = false; // Re-enable buttons after animation
    });

    // Show result in a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedSide == _result
              ? "You Won! It was $_result."
              : "You Lost! It was $_result.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _buildChoiceButton("Heads"),
                const SizedBox(width: 10),
                _buildChoiceButton("Tails"),
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
            GestureDetector(
              onTap: _isFlipping ? null : _flipCoin,
              child: RotationTransition(
                turns: _animation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFD700), // Coin color
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person, // Replace with coin face if available
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String side) {
    return GestureDetector(
      onTap: _isFlipping
          ? null
          : () {
              setState(() {
                _selectedSide = side;
              });
            },
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: _selectedSide == side
              ? const Color(0xFFFF686B)
              : const Color(0xFFFF9CA1),
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
        child: Text(
          side,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
