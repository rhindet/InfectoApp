import 'package:flutter/material.dart';

class ContactoView extends StatelessWidget {
  final VoidCallback? onClose;

  const ContactoView({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.98),
      body: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'Contenido de la vista de contacto',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),

    );
  }
}