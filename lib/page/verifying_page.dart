import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyingPage extends StatefulWidget {
  const VerifyingPage({super.key});

  @override
  State<VerifyingPage> createState() => _VerifyingPageState();
}

class _VerifyingPageState extends State<VerifyingPage> {
  late Future googleFontsPending;

  @override
  void initState() {
    getCurrentSession();
    googleFontsPending = GoogleFonts.pendingFonts([
      GoogleFonts.rubik(),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
    );
  }

  getCurrentSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isAuthorized = sharedPreferences.getBool("auth_status_k") ?? false;

    if (!isAuthorized) {
      if (!mounted) return;
      context.go('/auth');
    } else {
      if (!mounted) return;
      context.go('/home');
    }
  }
}
