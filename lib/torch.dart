import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FlashToggleButton extends StatefulWidget {
  const FlashToggleButton({super.key});

  @override
  State<FlashToggleButton> createState() => _FlashToggleButtonState();
}

class _FlashToggleButtonState extends State<FlashToggleButton> {
  bool isFlashOn = false;

  Future<void> toggleFlash() async {
    try {
      if (isFlashOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }

      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      print("Flash error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFlashOn ? Icons.flash_on : Icons.flash_off,
        color: isFlashOn ? Colors.yellow : Colors.grey,
        size: 32,
      ),
      onPressed: toggleFlash,
    );
  }
}
