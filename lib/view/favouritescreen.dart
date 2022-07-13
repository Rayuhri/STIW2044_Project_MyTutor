import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 11, 135, 160),
        title: Text('Favourite',
            style: GoogleFonts.pacifico(
                fontSize: 31,
                color: Colors.white,
                fontWeight: FontWeight.normal)),
      ),
    );
  }
}
