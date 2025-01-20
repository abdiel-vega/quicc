import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';

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
  bool _showIcon = false; // Controls icon visibility

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 3), // Default duration for the animation
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
      _showIcon = false; // Hide the icon while flipping
    });

    // Start the animation loop and determine the result when done
    _startAnimationLoop(3, () {
      setState(() {
        _isFlipping = false; // Re-enable interaction after animation
        _determineResult();
      });
    });
  }

  void _determineResult() {
    final isHeads = Random().nextBool(); // Randomly determine heads or tails
    final flipResult = isHeads ? "Heads" : "Tails";

    setState(() {
      _result = flipResult;
      _showIcon = true; // Show the icon after determining the result
    });

    // Show result with popup dialog
    _showResultDialogWithDelay();
  }

  void _showResultDialogWithDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Ensure the widget is still in the widget tree
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissal by tapping outside
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFF686B), // Dialog background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded borders
            ),
            title: Text(
              _selectedSide == _result ? "You Won!" : "You Lost!",
              style: const TextStyle(
                color: Colors.white, // Title text color
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "It was $_result.",
              style: const TextStyle(
                color: Colors.white, // Content text color
                fontSize: 18,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (route) => false, // Remove all previous routes
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Text color of the button
                  backgroundColor: const Color(0xFFFFA69E), // Background color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Button border radius
                  ),
                ),
                child: const Text(
                  "Go Back to Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Lottie.asset(
                        'lib/assets/flip-coin-animation.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller.duration = composition.duration;
                        },
                        fit: BoxFit.contain,
                        repeat: false,
                      ),
                    ),
                    Positioned(
                      top: 75, // Adjust this value to move the icon further up
                      child: AnimatedOpacity(
                        opacity: _showIcon
                            ? 1.0
                            : 0.0, // Control opacity based on _showIcon
                        duration: const Duration(seconds: 1), // Fade duration
                        child: Icon(
                          _result == "Heads"
                              ? Icons.person // Replace with Heads icon
                              : Icons.attach_money, // Replace with Tails icon
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
