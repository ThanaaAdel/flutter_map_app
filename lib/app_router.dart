import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/authphone/authphone_cubit.dart';
import 'constant/strings.dart';
import 'presentaion/screens/home_map_screen.dart';
import 'presentaion/screens/login_screen.dart';
import 'presentaion/screens/otp_screen.dart';

class AppRouter {
  AuthphoneCubit? authphoneCubit;
  AppRouter() {
    authphoneCubit = AuthphoneCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthphoneCubit>.value(
                  value: authphoneCubit!,
                  child: LoginScreen(),
                ));
      case otpScreen:
        final phoneNumber = settings.arguments;

        return MaterialPageRoute(

            builder: (_) => BlocProvider<AuthphoneCubit>.value(
              value: authphoneCubit!,
              child:  OtpScreen(phoneNumber:phoneNumber),
            ));
      case homeMapScreen:
        return MaterialPageRoute(builder: (_) =>  HomeMapScreen());
    }
    return null;
  }
}
