import 'dart:developer';

import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(CheckUserLoggedInEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationInitial) {
            Future.delayed(
              const Duration(seconds: 3),
              () {
                state.isUserSignedIn
                    ? Navigator.pushNamedAndRemoveUntil(
                        context,
                        "bottomNav_Navigator",
                        (route) => false,
                      )
                    : Navigator.pushNamed(
                        context,
                        "welcome_page",
                      );
              },
            );
          }
          if (state is AuthenticationErrorState) {
            log("Auth status error: splash : ${state.message}");
            return commonSnackBarWidget(context: context, contentText: "${state.message}");
          }
        },
        child: const Center(
          child: AppIconHoldWidget(),
        ),
      ),
    );
  }
}
