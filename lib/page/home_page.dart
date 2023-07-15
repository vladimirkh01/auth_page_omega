import 'package:auth_page/widget/font/auth_page_font.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getAuthParam(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    snapshot.data[0],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    snapshot.data[1],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: _logOut,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 8.w, top: 3.5.w, right: 8.w, bottom: 3.5.w),
                    decoration: BoxDecoration(
                        color: const Color(0xffA04ACF),
                        borderRadius: BorderRadius.circular(10)),
                    width: 84.w,
                    child: Center(
                        child: Text('Выйти', style: AuthPageFont().sendAuth)),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  _getAuthParam() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return [
      sharedPreferences.getString('auth_access_token_k') ?? '',
      sharedPreferences.getString('auth_refresh_token_k') ?? '',
    ];
  }

  _logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    if (!mounted) return;
    context.go('/auth');
  }
}
