import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({Key? key}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 11, 135, 160),
        title: Text('Subscribe Us',
            style: GoogleFonts.pacifico(
                fontSize: 31,
                color: Colors.white,
                fontWeight: FontWeight.normal)),
      ),
      body: const Center(
        child: Text("This is subscribe page."),
      ),
    );
  }
}
