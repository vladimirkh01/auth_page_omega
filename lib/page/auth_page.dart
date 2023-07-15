import 'dart:ui';

import 'package:auth_page/network/request/dio_request.dart';
import 'package:auth_page/widget/font/auth_page_font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _focusEmail.addListener(_onFocusChangeEmailInput);
    _focusPassword.addListener(_onFocusChangePasswordInput);
    super.initState();
  }

  @override
  void dispose() {
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        if (deviceType == DeviceType.mobile) {
          return mobileAuth();
        } else if (deviceType == DeviceType.web &&
            MediaQuery.of(context).size.width >= 1236) {
          return webAuth();
        } else if (deviceType == DeviceType.web &&
            MediaQuery.of(context).size.width < 1236 &&
            MediaQuery.of(context).size.width >= 582) {
          return desktopAuth();
        } else if (MediaQuery.of(context).size.width < 582) {
          return mobileAuth();
        } else if (deviceType == DeviceType.mac ||
            deviceType == DeviceType.windows) {
          return desktopAuth();
        } else if (deviceType == DeviceType.tablet &&
            orientation == Orientation.landscape) {
          return tabletAuth();
        } else if (deviceType == DeviceType.tablet &&
            orientation == Orientation.portrait) {
          return mobileAuth();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _onFocusChangeEmailInput() {
    setState(() {});
  }

  _onFocusChangePasswordInput() {
    setState(() {});
  }

  _logInRequest() {
    setState(() => _isLoading = true);
    DioRequest()
        .logIn(_controllerEmail.text, _controllerPassword.text)
        .then((value) async {
      setState(() => _isLoading = false);
      if (value != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool('auth_status_k', true);

        sharedPreferences.setString(
            'auth_access_token_k', value[0]["accessToken"]);

        sharedPreferences.setString(
            'auth_refresh_token_k', value[0]["refreshToken"]);

        if (!mounted) return;
        context.go('/home');
      }
    });
  }

  Widget mobileAuth() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/phone/bg_phone.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 3.w, right: 3.w),
              width: 100.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                      padding: EdgeInsets.all(7.w),
                      color: const Color.fromRGBO(255, 255, 255, 0.75),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Вход",
                            style: AuthPageFont().titleAuth,
                          ),
                          SizedBox(
                            height: 1.55.h,
                          ),
                          Text(
                            "Введите данные, чтобы войти в личный кабинет.",
                            style: AuthPageFont().descAuth,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          TextField(
                            controller: _controllerEmail,
                            focusNode: _focusEmail,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(5.w),
                              labelText: 'E-mail',
                              hintStyle:
                                  const TextStyle(color: Color(0xffAA9EFF)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFFAA9EFF), width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7D6EE9), width: 2.0),
                                  borderRadius: BorderRadius.circular(10)),
                              labelStyle:
                                  const TextStyle(color: Color(0xFF7D6EE9)),
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          TextField(
                            controller: _controllerPassword,
                            focusNode: _focusPassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) => _logInRequest(),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(5.w),
                              labelText: 'Пароль',
                              hintStyle:
                                  const TextStyle(color: Color(0xffAA9EFF)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFFAA9EFF), width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7D6EE9), width: 2.0),
                                  borderRadius: BorderRadius.circular(10)),
                              labelStyle:
                                  const TextStyle(color: Color(0xFF7D6EE9)),
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Забыли пароль?",
                                style: AuthPageFont().forgotPassword,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          InkWell(
                            onTap: _logInRequest,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8.w,
                                  top: 3.5.w,
                                  right: 8.w,
                                  bottom: 3.5.w),
                              decoration: BoxDecoration(
                                  color: const Color(0xffA04ACF),
                                  borderRadius: BorderRadius.circular(10)),
                              width: 84.w,
                              child: Center(
                                  child: !_isLoading
                                      ? Text('Войти',
                                          style: AuthPageFont().sendAuth)
                                      : SizedBox(
                                          width: 5.75.w,
                                          height: 5.75.w,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 1.7,
                                            color: Colors.white,
                                          ),
                                        )),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 13.w,
                                child: Divider(
                                  color: const Color(0xff59607A),
                                  thickness: 0.3.w,
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Или войдите с помощью:",
                                style: AuthPageFont().descAuth,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              SizedBox(
                                width: 13.w,
                                child: Divider(
                                  color: const Color(0xff59607A),
                                  thickness: 0.3.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset('image/phone/ya_phone.png'),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset('image/phone/go_phone.png'),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset('image/phone/vk_phone.png'),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.58.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Еще нет аккаунта?",
                                style: AuthPageFont().descAuth,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Зарегистрируйтесь",
                                style: AuthPageFont().createAccount,
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget webAuth() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 70.w, top: 1.h),
                width: 100.w,
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Для вас',
                      style: AuthPageFont().titleWebHeader,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      'Для бизнеса',
                      style: AuthPageFont().titleWebHeader,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      'Для разработчиков',
                      style: AuthPageFont().titleWebHeader,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.w, top: 1.h, bottom: 1.5.h),
                width: 100.w,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('image/web/ic_web.png'),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Игры',
                      style: AuthPageFont().mainTitleWebHeader,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Приложения',
                      style: AuthPageFont().mainTitleWebHeader,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Сообщество',
                      style: AuthPageFont().mainTitleWebHeader,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Турнир',
                      style: AuthPageFont().mainTitleWebHeader,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Справка',
                      style: AuthPageFont().mainTitleWebHeader,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    SizedBox(
                      width: 20.w,
                      height: 4.5.h,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(1.4.w),
                          labelText: 'Поиск',
                          suffixIcon: Image.asset('image/web/search.png'),
                          hintStyle:
                              GoogleFonts.rubik(color: const Color(0xffAA9EFF)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFFAA9EFF), width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF7D6EE9), width: 3.0),
                              borderRadius: BorderRadius.circular(10)),
                          labelStyle:
                              GoogleFonts.rubik(color: const Color(0xFF7D6EE9)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Image.asset('image/web/cart.png'),
                    SizedBox(
                      width: 1.w,
                    ),
                    Image.asset('image/web/favourite.png'),
                    SizedBox(
                      width: 1.w,
                    ),
                    Image.asset('image/web/login.png'),
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("image/web/bg_web.png"),
                              fit: BoxFit.cover)),
                    ),
                    Column(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(left: 9.w, right: 3.w, top: 9.w),
                          width: 33.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.75),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Вход",
                                        style: AuthPageFont().titleAuthWeb,
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        "Введите данные, чтобы войти в личный кабинет.",
                                        style: AuthPageFont().descAuthWeb,
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      TextField(
                                        controller: _controllerEmail,
                                        focusNode: _focusEmail,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          contentPadding: EdgeInsets.all(1.4.w),
                                          labelText: 'E-mail',
                                          hintStyle: const TextStyle(
                                              color: Color(0xffAA9EFF)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFAA9EFF),
                                                width: 3.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF7D6EE9),
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelStyle: const TextStyle(
                                              color: Color(0xFF7D6EE9)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      TextField(
                                        controller: _controllerPassword,
                                        focusNode: _focusPassword,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        textInputAction: TextInputAction.go,
                                        onSubmitted: (value) => _logInRequest(),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          contentPadding: EdgeInsets.all(1.4.w),
                                          labelText: 'Пароль',
                                          hintStyle: const TextStyle(
                                              color: Color(0xffAA9EFF)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFAA9EFF),
                                                width: 3.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF7D6EE9),
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelStyle: const TextStyle(
                                              color: Color(0xFF7D6EE9)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Забыли пароль?",
                                            style: AuthPageFont()
                                                .forgotPasswordWeb,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      InkWell(
                                        onTap: _logInRequest,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 2.5.w,
                                              top: 0.5.w,
                                              right: 2.w,
                                              bottom: 0.5.w),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffA04ACF),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: 84.w,
                                          child: Center(
                                              child: !_isLoading
                                                  ? Text('Войти',
                                                      style: AuthPageFont()
                                                          .sendAuthWeb)
                                                  : SizedBox(
                                                      width: 1.53.w,
                                                      height: 1.53.w,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeWidth: 1.7,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 7.w,
                                            child: Divider(
                                              color: const Color(0xff59607A),
                                              thickness: 0.08.w,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.2.w,
                                          ),
                                          Text(
                                            "Или войдите с помощью:",
                                            style: AuthPageFont().descAuthWeb,
                                          ),
                                          SizedBox(
                                            width: 1.2.w,
                                          ),
                                          SizedBox(
                                            width: 7.w,
                                            child: Divider(
                                              color: const Color(0xff59607A),
                                              thickness: 0.08.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(1.5.w),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Image.asset(
                                                'image/phone/ya_phone.png'),
                                          ),
                                          SizedBox(
                                            width: 2.5.w,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(1.5.w),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Image.asset(
                                                'image/phone/go_phone.png'),
                                          ),
                                          SizedBox(
                                            width: 2.5.w,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(1.5.w),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Image.asset(
                                                'image/phone/vk_phone.png'),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Еще нет аккаунта?",
                                            style: AuthPageFont().descAuthWeb,
                                          ),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          Text(
                                            "Зарегистрируйтесь",
                                            style:
                                                AuthPageFont().createAccountWeb,
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                width: 100.w,
                color: const Color(0xFF2A083D),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 13.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Компания',
                                style: AuthPageFont().mainTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Omega Studio',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Работа в Omega Studio',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'Разработчикам',
                                style: AuthPageFont().mainTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Справка',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        SizedBox(
                          width: 13.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Пользователям',
                                style: AuthPageFont().mainTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Пользовательское соглашение',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Политика конфиденциальности',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Политика использования файлов cookie',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Справка',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        SizedBox(
                          width: 13.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Бизнесу',
                                style: AuthPageFont().mainTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Контакты',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Новости',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Справка',
                                style: AuthPageFont().textUnderTitleWebFooter,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 25.w,
                        ),
                        SizedBox(
                          width: 15.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('image/web/download_button.png'),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 6.w,
                                    child: Text(
                                      'Социальные сети:',
                                      style: AuthPageFont()
                                          .textUnderTitleWebFooter,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.5.w,
                                  ),
                                  SizedBox(
                                    width: 8.2.w,
                                    child: Image.asset(
                                        'image/web/social_media.png'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    const SizedBox(
                      child: Divider(
                        color: Color(0xFF9BA4C1),
                        thickness: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '© 2023 ООО «ОМЕГА СТУДИО»',
                              style: AuthPageFont().textUnderDataWebFooter,
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              'ИНН: 3528327105, ОГРН: 1213500003122',
                              style: AuthPageFont().textUnderDataWebFooter,
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              '162608, Вологодская область, г. Череповец, ул Белинского, д. 1/3',
                              style: AuthPageFont().textUnderDataWebFooter,
                            ),
                          ],
                        ),
                        Image.asset('image/web/footer_logo.png')
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget desktopAuth() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 1.w),
                width: 100.w,
                height: 7.5.h,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'image/desktop/ic_desktop.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 100.h - 7.5.h,
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("image/desktop/bg_desktop.png"),
                              fit: BoxFit.cover)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 45.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.75),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Вход",
                                          style: AuthPageFont().titleAuthDes,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "Введите данные, чтобы войти в личный кабинет.",
                                          style: AuthPageFont().descAuthDes,
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        TextField(
                                          controller: _controllerEmail,
                                          focusNode: _focusEmail,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.all(1.4.w),
                                            labelText: 'E-mail',
                                            hintStyle: const TextStyle(
                                                color: Color(0xffAA9EFF)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFAA9EFF),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF7D6EE9),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            labelStyle: const TextStyle(
                                                color: Color(0xFF7D6EE9)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        TextField(
                                          controller: _controllerPassword,
                                          focusNode: _focusPassword,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          textInputAction: TextInputAction.go,
                                          onSubmitted: (value) =>
                                              _logInRequest(),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.all(1.4.w),
                                            labelText: 'Пароль',
                                            hintStyle: const TextStyle(
                                                color: Color(0xffAA9EFF)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFAA9EFF),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF7D6EE9),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            labelStyle: const TextStyle(
                                                color: Color(0xFF7D6EE9)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Забыли пароль?",
                                              style: AuthPageFont()
                                                  .forgotPasswordWeb,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        InkWell(
                                          onTap: _logInRequest,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 2.w,
                                                top: 1.w,
                                                right: 2.w,
                                                bottom: 1.w),
                                            decoration: BoxDecoration(
                                                color: const Color(0xffA04ACF),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 84.w,
                                            child: Center(
                                                child: !_isLoading
                                                    ? Text('Войти',
                                                        style: AuthPageFont()
                                                            .sendAuthDes)
                                                    : SizedBox(
                                                        width: 2.53.w,
                                                        height: 2.53.w,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 1.7,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 8.5.w,
                                              child: Divider(
                                                color: const Color(0xff59607A),
                                                thickness: 0.08.w,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              "Или войдите с помощью:",
                                              style: AuthPageFont().descAuthDes,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            SizedBox(
                                              width: 8.5.w,
                                              child: Divider(
                                                color: const Color(0xff59607A),
                                                thickness: 0.08.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.w,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(1.5.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'image/phone/ya_phone.png'),
                                            ),
                                            SizedBox(
                                              width: 2.5.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(1.5.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'image/phone/go_phone.png'),
                                            ),
                                            SizedBox(
                                              width: 2.5.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(1.5.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'image/phone/vk_phone.png'),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.w,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Еще нет аккаунта?",
                                              style: AuthPageFont().descAuthDes,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              "Зарегистрируйтесь",
                                              style: AuthPageFont()
                                                  .createAccountDes,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tabletAuth() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("image/tablet/bg_tablet.png"),
                              fit: BoxFit.cover)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 45.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.75),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Вход",
                                          style: AuthPageFont().titleAuthDes,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "Введите данные, чтобы войти в личный кабинет.",
                                          style: AuthPageFont().descAuthDes,
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        TextField(
                                          controller: _controllerEmail,
                                          focusNode: _focusEmail,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.all(1.4.w),
                                            labelText: 'E-mail',
                                            hintStyle: const TextStyle(
                                                color: Color(0xffAA9EFF)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFAA9EFF),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF7D6EE9),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            labelStyle: const TextStyle(
                                                color: Color(0xFF7D6EE9)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        TextField(
                                          controller: _controllerPassword,
                                          focusNode: _focusPassword,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          textInputAction: TextInputAction.go,
                                          onSubmitted: (value) =>
                                              _logInRequest(),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.all(1.4.w),
                                            labelText: 'Пароль',
                                            hintStyle: const TextStyle(
                                                color: Color(0xffAA9EFF)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFAA9EFF),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF7D6EE9),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            labelStyle: const TextStyle(
                                                color: Color(0xFF7D6EE9)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Забыли пароль?",
                                              style: AuthPageFont()
                                                  .forgotPasswordWeb,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        InkWell(
                                          onTap: _logInRequest,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 2.w,
                                                top: 1.w,
                                                right: 2.w,
                                                bottom: 1.w),
                                            decoration: BoxDecoration(
                                                color: const Color(0xffA04ACF),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 84.w,
                                            child: Center(
                                                child: !_isLoading
                                                    ? Text('Войти',
                                                        style: AuthPageFont()
                                                            .sendAuthDes)
                                                    : SizedBox(
                                                        width: 2.53.w,
                                                        height: 2.53.w,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 1.7,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 8.5.w,
                                              child: Divider(
                                                color: const Color(0xff59607A),
                                                thickness: 0.08.w,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              "Или войдите с помощью:",
                                              style: AuthPageFont().descAuthDes,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            SizedBox(
                                              width: 8.5.w,
                                              child: Divider(
                                                color: const Color(0xff59607A),
                                                thickness: 0.08.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.w,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(1.5.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'image/phone/ya_phone.png'),
                                            ),
                                            SizedBox(
                                              width: 2.5.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(1.5.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'image/phone/go_phone.png'),
                                            ),
                                            SizedBox(
                                              width: 2.5.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(1.5.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'image/phone/vk_phone.png'),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.w,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Еще нет аккаунта?",
                                              style: AuthPageFont().descAuthDes,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              "Зарегистрируйтесь",
                                              style: AuthPageFont()
                                                  .createAccountDes,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
