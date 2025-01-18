import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FlipACoinPage extends StatefulWidget {
  const FlipACoinPage({super.key});

  @override
  State<FlipACoinPage> createState() => _FlipACoinPageState();
}

class _FlipACoinPageState extends State<FlipACoinPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String? _selectedSide; // Tracks whether the user selects Heads or Tails
  String _result = ""; // Stores the result of the coin flip
  bool _isFlipping = false; // Prevent interaction during animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimationLoop(int maxLoops, VoidCallback onComplete) {
    int loopCount = 0; // Track the number of completed loops

    void playNextLoop() {
      if (loopCount < maxLoops) {
        _controller.forward(from: 0).whenComplete(() {
          loopCount++;
          playNextLoop(); // Start the next loop
        });
      } else {
        _controller.stop();
        onComplete(); // Call the completion callback
      }
    }

    playNextLoop(); // Start the first loop
  }

  void _flipCoin() {
    if (_selectedSide == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Heads or Tails!")),
      );
      return;
    }

    setState(() {
      _isFlipping = true;
    });

    // Start the animation loop and determine the result when done
    _startAnimationLoop(3, () {
      setState(() {
        _isFlipping = false; // Re-enable interaction after animation
      });
      _determineResult();
    });
  }

  void _determineResult() {
    final isHeads = Random().nextBool(); // Randomly determine heads or tails
    final flipResult = isHeads ? "Heads" : "Tails";

    setState(() {
      _result = flipResult;
      _isFlipping = false; // Re-enable interaction
    });

    // Show result with SnackBar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF84DCC6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Material(
          elevation: 4.0,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20.0),
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
              child: Center(
                // Centers the animation
                child: SizedBox(
                  width: 480, // Adjust size as necessary
                  height: 480,
                  child: Lottie.asset(
                    'lib/assets/flip-coin-animation.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller.duration = composition.duration;
                    },
                    fit: BoxFit.contain, // Ensures proper scaling
                    alignment:
                        Alignment.center, // Aligns the animation to the center
                    repeat: false, // Play only once when tapped
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
